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
import RxGesture

class ProfileEditViewController: UIViewController {
    
    var viewModel: ProfileEditViewModel?
    private let disposeBag = DisposeBag()
    
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
    
    lazy var nickNameField = ProfileEditFieldView(title: "닉네임", validation: 12)
    lazy var goalField = ProfileEditFieldView(title: "한줄목표", validation: 20)
    lazy var jobField = ProfileEditFieldView(title: "직업", validation: nil)
    lazy var interestField = ProfileEditFieldView(title: "관심사", validation: nil)
    
    lazy var textFieldStack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 24
    }
    
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
    }
    
    private func configureUI() {
        
        // TODO: Gradient 효과와 함께 추가
//        profileImageView.addSubview(profileImageEditLabel)
//        profileImageEditLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(52)
//            make.left.right.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
        
        [nickNameField, goalField, jobField, interestField].forEach { textFieldStack.addArrangedSubview($0) }
        
        [profileImageView, textFieldStack, bottomButton].forEach { self.view.addSubview($0) }
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
            make.height.equalTo(80)
            make.width.equalTo(80)
            make.centerX.equalToSuperview()
        }
        
        textFieldStack.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
        }

        bottomButton.enable(string: "완료")
        bottomButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-WBottmButton.buttonOffset)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
    }
    
    private func bindViewModel() {
        
        let input = ProfileEditViewModel.Input(
            didImageTap: profileImageView.rx.tapGesture().asObservable(),
            didJobTap: jobField.textField.rx.tapGesture().asObservable(),
            didInterestTap: interestField.textField.rx.tapGesture().asObservable(),
            didButtonTap: bottomButton.rx.tap.asObservable()
        )
        
        let output = viewModel?.transform(input: input)
        
        output?.userDetail.subscribe(onNext: { userData in
            self.setData(user: userData)
            self.selectedJobs = userData.job
            self.selectedInterests = userData.interest
        }).disposed(by: disposeBag)
        
        bottomButton.rx.tap.subscribe(onNext: { _ in
            
            let update = UserUpdate(
                name: self.nickNameField.textField.text ?? "",
                goal: self.goalField.textField.text ?? "",
                imageFileName: "",
                job: self.selectedJobs,
                interest: self.selectedInterests
            )
            
            PublishSubject<UserUpdate>.just(update).bind(to: self.viewModel!.userUpdate).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
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
        jobField.textField.text = user.job.joined(separator: ", ")
        interestField.textField.text = user.interest.joined(separator: ", ")
    }
    
    func setJob(selected: [String]) {
        self.jobField.textField.text = selected.joined(separator: ", ")
    }
    
    func setInterest(selected: [String]) {
        self.interestField.textField.text = selected.joined(separator: ", ")
    }
}
