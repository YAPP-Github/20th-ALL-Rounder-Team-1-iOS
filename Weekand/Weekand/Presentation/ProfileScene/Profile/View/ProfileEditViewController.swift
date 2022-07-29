//
//  ProfileEditViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/22.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay
import RxGesture

class ProfileEditViewController: BaseViewController {
    
    var viewModel: ProfileEditViewModel?
    private let disposeBag = DisposeBag()
    let imagePickerController = UIImagePickerController()
    
    var updatedProfile = PublishRelay<UserUpdate>()
    var updatedImage = PublishRelay<UIImage>()
    var endEditing = PublishRelay<Void>()
    
    var selectedJobs: [String] = [] {
        didSet {
            self.setJob(selected: self.selectedJobs)
        }
    }
    var selectedInterests: [String] = [] {
        didSet {
            self.setInterest(selected: self.selectedInterests)
        }
    }
    
    // MARK: profile image
    lazy var profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.image = UIImage(named: "default.person")
    }
    
    lazy var profileImageEditLabel = UILabel().then {
        $0.text = "수정"
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    lazy var profileImageContainerView = UIView()
    
    // MARK: Fields
    lazy var nickNameField = ProfileEditFieldView(title: "닉네임", validation: 12)
    lazy var goalField = ProfileEditFieldView(title: "한줄목표", validation: 20)
    lazy var jobField = ProfileEditSelectionView(title: "직업")
    lazy var interestField = ProfileEditSelectionView(title: "관심사")
    
    lazy var textFieldStack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 24
    }
    
    // MARK: Button
    lazy var bottomButton = WBottmButton(title: "완료")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        bindViewModel()
        
    }
    
    private func setUpView() {
        self.title = "프로필 수정"
        self.view.backgroundColor = .backgroundColor
        
        imagePickerController.delegate = self
    }
    
    private func configureUI() {
        
        // TODO: Gradient 효과와 함께 추가
//        profileImageView.addSubview(profileImageEditLabel)
//        profileImageEditLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(52)
//            make.left.right.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
        
        profileImageContainerView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(24)
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
        
        [nickNameField, goalField, jobField, interestField].forEach { textFieldStack.addArrangedSubview($0) }
        
        [profileImageContainerView, textFieldStack].forEach { self.stackView.addArrangedSubview($0) }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-WBottmButton.buttonOffset - 64)
            make.trailing.leading.equalToSuperview().inset(24)
        }
        
        self.contentView.addSubview(stackView)

        self.view.addSubview(bottomButton)
        bottomButton.enable(string: "완료")
        bottomButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-WBottmButton.buttonOffset)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        profileImageView.rx.tapGesture().bind { _ in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
    }
    
    private func bindViewModel() {
        
        bottomButton.rx.tap.subscribe(onNext: { _ in
            let profile = UserUpdate(
                name: self.nickNameField.textField.text,
                goal: self.goalField.textField.text,
                imageFileName: nil,
                job: self.selectedJobs,
                interest: self.selectedInterests
            )
            PublishRelay<UserUpdate>.just(profile).bind(to: self.updatedProfile).disposed(by: self.disposeBag)
            
            guard let image = self.profileImageView.image else { return }
            PublishRelay<UIImage>.just(image).bind(to: self.updatedImage).disposed(by: self.disposeBag)
            
            PublishRelay<Void>.just(()).bind(to: self.endEditing).disposed(by: self.disposeBag)
            
        }).disposed(by: disposeBag)
        
        let input = ProfileEditViewModel.Input(
            didImageTap: profileImageView.rx.tapGesture().asObservable(),
            didJobTap: jobField.labelBackground.rx.tapGesture().asObservable(),
            didInterestTap: interestField.labelBackground.rx.tapGesture().asObservable(),
            didButtonTap: endEditing.asObservable(),
            
            profileDataChanged: updatedProfile.asObservable(),
            profileImageChanged: updatedImage.asObservable()
        )
        
        let output = viewModel?.transform(input: input)
        
        output?.userDetail.subscribe(onNext: { userData in
            self.setData(user: userData)
            self.selectedJobs = userData.job
            self.selectedInterests = userData.interest
        }).disposed(by: disposeBag)
        
        output?.alertText.subscribe(onNext: { text in
            self.showToast(message: text)
        }).disposed(by: disposeBag)
        
        bottomButton.rx.tap.subscribe(onNext: { _ in
            
            let update = UserUpdate(
                name: self.nickNameField.textField.text ?? "",
                goal: self.goalField.textField.text ?? "",
                imageFileName: "",
                job: self.selectedJobs,
                interest: self.selectedInterests
            )
            
            PublishRelay<UserUpdate>.just(update).bind(to: self.viewModel!.userUpdate).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
}

// MARK: Photo Picker
extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage]{
            profileImageView.image = image as? UIImage
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileEditViewController {
    func setData(user: UserDetail) {
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: user.imagePath) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: imageData)
            }
        }
        
        nickNameField.textField.text = user.name
        goalField.textField.text = user.goal
        jobField.selectedLabel.text = user.job.joined(separator: ", ")
        interestField.selectedLabel.text = user.interest.joined(separator: ", ")
    }
    
    func setJob(selected: [String]) {
        self.jobField.selectedLabel.text = selected.joined(separator: ", ")
    }
    
    func setInterest(selected: [String]) {
        self.interestField.selectedLabel.text = selected.joined(separator: ", ")
    }
}
