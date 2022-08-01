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
import Photos

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
        
        self.requestPhotoAuth()
    }
        
    private func setUpView() {
        self.title = "프로필 수정"
        self.view.backgroundColor = .backgroundColor
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
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
        
        profileImageView.rx.tapGesture().when(.recognized).bind { _ in
                

            if self.checkPhotoAuth() {
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: true, completion: nil)
            } else {
                self.AuthSettingOpen()
            }
            
                        
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
            self.updatedProfile.accept(profile)
            
            guard let image = self.profileImageView.image else { return }
            self.updatedImage.accept(image)
            self.endEditing.accept(())
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
            
            self.viewModel?.userUpdate.accept(update)
        }).disposed(by: disposeBag)
    }
}

// MARK: Photo Picker
extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    /// 권한 설정을 한적 없는 경우 권한 요청
    func requestPhotoAuth() {
        
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (state) in
                print(state)
            }
        }
    }
    
    /// 앨범 권한 확인
    func checkPhotoAuth() -> Bool {
            
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch authorizationStatus {
        // Accepted
        case .authorized: return true
        case .limited: return true
            
        // Denied
        case .denied: return false
        case .restricted: return false
            
        // Need Request
        case .notDetermined: return false
        default: break
        }
        
        return false
    }
    
    /// 권한이 없을 시 재요청
    func AuthSettingOpen() {
        
        let message = "프로필을 설정하려면 앨범 권한이 필요해요! \r\n 설정화면에서 허용해주세요"
        let alert = UIAlertController(title: "설정", message: message, preferredStyle: .alert)

        let cancel = UIAlertAction(title: "취소", style: .default) { (UIAlertAction) in
            print("\(String(describing: UIAlertAction.title))")
        }
        
        let confirm = UIAlertAction(title: "설정하기", style: .default) { (UIAlertAction) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }

        alert.addAction(confirm)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ProfileEditViewController {
    func setData(user: UserDetail) {
        
        DispatchQueue.global().async {
            if let cachedImage = ImageCacheManager.shared.loadCachedData(for: user.imagePath) {
                DispatchQueue.main.async {
                    self.profileImageView.image = cachedImage
                }
            } else {
                guard let imageURL = URL(string: user.imagePath) else { return }
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                guard let image = UIImage(data: imageData) else { return }
                
                ImageCacheManager.shared.setCacheData(of: image, for: user.imagePath)
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
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
