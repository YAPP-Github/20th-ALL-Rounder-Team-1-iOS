//
//  AddInformationViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/25.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import AlignedCollectionViewFlowLayout

class SignUpAddInfomationViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: SignUpAddInfomationViewModel?
    
    lazy var welcomeLabel = WTitleLabel().then {
        $0.setText(string: "조금 더 알려주시겠어요?")
    }
    
    lazy var jobStackView = InformationGroupStackView().then {
        $0.setNameLabelText(string: "직업")
        $0.setInformlabelText(string: "최대 3개까지 선택할 수 있어요")
    }
    
    lazy var interestsStackView = InformationGroupStackView().then {
        $0.setNameLabelText(string: "관심사")
        $0.setInformlabelText(string: "최대 3개까지 선택할 수 있어요")
    }
    
    lazy var confirmButton = WBottmButton().then {
        $0.setTitle("다음", for: .normal)
        $0.enable(string: "다음")
    }
    
    let selectedJobs = PublishRelay<[String]>()
    let selectedInterests = PublishRelay<[String]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "추가 정보"
        stackView.spacing = 30
        stackView.distribution = .fill
        
        jobStackView.collectionView.dataSource = self
        jobStackView.collectionView.delegate = self
        jobStackView.collectionView.allowsMultipleSelection = true
        jobStackView.collectionView.register(InformationCollectionViewCell.self, forCellWithReuseIdentifier: InformationCollectionViewCell.cellIdentifier)
        
        interestsStackView.collectionView.dataSource = self
        interestsStackView.collectionView.delegate = self
        interestsStackView.collectionView.allowsMultipleSelection = true
        interestsStackView.collectionView.register(InformationCollectionViewCell.self, forCellWithReuseIdentifier: InformationCollectionViewCell.cellIdentifier)
    }

    private func configureUI() {
        [welcomeLabel, jobStackView, interestsStackView].forEach { stackView.addArrangedSubview($0) }
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.bottom.equalToSuperview().offset(-WBottmButton.buttonOffset - 64)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-WBottmButton.buttonOffset)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(view)
        }
    }
    
    private func bindViewModel() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        let input = SignUpAddInfomationViewModel.Input(
            selectedJobs: selectedJobs,
            selectedInterests: selectedInterests,
            nextButtonDidTapEvent: confirmButton.rx.tap.asObservable()
        )
        
        let _ = viewModel.transform(input: input)
    }
}

extension SignUpAddInfomationViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == jobStackView.collectionView {
            return Constants.jobDataSource.count
        } else {
            return Constants.interestsDataSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == jobStackView.collectionView {
            return Constants.jobDataSource[section].count
        } else {
            return Constants.interestsDataSource[section].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == jobStackView.collectionView {
            guard let cell = jobStackView.collectionView.dequeueReusableCell(withReuseIdentifier: InformationCollectionViewCell.cellIdentifier, for: indexPath) as? InformationCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(text: Constants.jobDataSource[indexPath.section][indexPath.item])
            return cell
        } else {
            guard let cell = interestsStackView.collectionView.dequeueReusableCell(withReuseIdentifier: InformationCollectionViewCell.cellIdentifier, for: indexPath) as? InformationCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(text: Constants.interestsDataSource[indexPath.section][indexPath.item])
            return cell
        }
    }
}

extension SignUpAddInfomationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == jobStackView.collectionView {
            let jobs = jobStackView.collectionView
                        .indexPathsForSelectedItems?
                        .map { Constants.jobDataSource[$0.section][$0.item] }
            self.selectedJobs.accept(jobs ?? [])
        } else {
            let interests = interestsStackView.collectionView
                        .indexPathsForSelectedItems?
                        .map { Constants.interestsDataSource[$0.section][$0.item] }
            self.selectedJobs.accept(interests ?? [])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == jobStackView.collectionView {
            let jobs = jobStackView.collectionView
                        .indexPathsForSelectedItems?
                        .map { Constants.jobDataSource[$0.section][$0.item] }
            self.selectedJobs.accept(jobs ?? [])
        } else {
            let interests = interestsStackView.collectionView
                        .indexPathsForSelectedItems?
                        .map { Constants.interestsDataSource[$0.section][$0.item] }
            self.selectedJobs.accept(interests ?? [])
        }
    }
}

#if canImport(SwiftUI) && DEBUG

struct AddInformationViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            SignUpAddInfomationViewController().showPreview(.iPhone8)
        }
    }
}
#endif
