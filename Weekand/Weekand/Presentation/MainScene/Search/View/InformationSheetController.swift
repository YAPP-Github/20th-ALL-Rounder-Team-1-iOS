//
//  InformationSheetController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/18.
//

import UIKit
import RxSwift
import RxCocoa
import AlignedCollectionViewFlowLayout

class InformationSheetController: BottomSheetViewController {
    
    enum InformationType: String {
        case job = "직업"
        case interests = "관심사"
    }
    
    // ViewMoel
    
    private let disposeBag = DisposeBag()
    var viewModel: InformationSheetViewModel?
    
    // SheetHeight
    
    override var bottomSheetHeight: CGFloat {
        get {
            return 420
        }
    }
    
    // Views

    lazy var sheetTitle = WTextLabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray900
        $0.text = informationType.rawValue
    }
    
    lazy var collectionViewFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top).then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 7
        $0.estimatedItemSize = CGSize(width: 53, height: 38)
        $0.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    lazy var confirmButton = WDefaultButton(title: "확인", style: .filled, font: WFont.subHead1())
    
    // property
    
    let selectedInformations = PublishRelay<[String]>()
    let dropDownDidSelectEvent = PublishRelay<UserSort>()
    
    let informationType: InformationType
    
    init(informationType: InformationType) {
        self.informationType = informationType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        bindViewModel()
    }
    
    private func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(InformationCollectionViewCell.self, forCellWithReuseIdentifier: InformationCollectionViewCell.cellIdentifier)
    }
    
    private func configureUI() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let sideSpacing = screenWidth * 0.064
        
        bottomSheetView.addSubview(sheetTitle)
        sheetTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(sideSpacing)
            make.leading.equalToSuperview().offset(sideSpacing)
        }
        
        bottomSheetView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sheetTitle.snp.bottom).offset(screenHeight * 0.015)
            make.leading.equalToSuperview().offset(sideSpacing)
            make.trailing.equalToSuperview().offset(-sideSpacing)
            make.height.equalTo(screenHeight * 0.4)
        }
        
        bottomSheetView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(sideSpacing)
            make.trailing.equalToSuperview().offset(-sideSpacing)
            make.bottom.equalToSuperview().offset(-screenHeight * 0.04)
            make.height.equalTo(52)
        }
    }
    
    private func bindViewModel() {
        
        let input = InformationSheetViewModel.Input(
            selectedInformations: selectedInformations,
            didTapConfirmButton: confirmButton.rx.tap.asObservable()
        )
        
        let output = viewModel?.transform(input: input)
    }
}

extension InformationSheetController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if informationType == .job {
            return Constants.jobDataSource.count
        } else {
            return Constants.interestsDataSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if informationType == .job {
            return Constants.jobDataSource[section].count
        } else {
            return Constants.interestsDataSource[section].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if informationType == .job {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InformationCollectionViewCell.cellIdentifier, for: indexPath) as? InformationCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(text: Constants.jobDataSource[indexPath.section][indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InformationCollectionViewCell.cellIdentifier, for: indexPath) as? InformationCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(text: Constants.interestsDataSource[indexPath.section][indexPath.item])
            return cell
        }
    }
    
}

extension InformationSheetController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if informationType == .job {
            if let jobs = collectionView.indexPathsForSelectedItems,
               jobs.count <= 2 {
                return true
            } else {
                return false
            }
        } else {
            if let interests = collectionView.indexPathsForSelectedItems,
               interests.count <= 2 {
                return true
            } else {
                return false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if informationType == .job {
            let jobs = collectionView
                        .indexPathsForSelectedItems?
                        .map { Constants.jobDataSource[$0.section][$0.item] }
            self.selectedInformations.accept(jobs ?? [])
        } else {
            let interests = collectionView
                        .indexPathsForSelectedItems?
                        .map { Constants.interestsDataSource[$0.section][$0.item] }
            self.selectedInformations.accept(interests ?? [])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if informationType == .job {
            let jobs = collectionView
                        .indexPathsForSelectedItems?
                        .map { Constants.jobDataSource[$0.section][$0.item] }
            self.selectedInformations.accept(jobs ?? [])
        } else {
            let interests = collectionView
                        .indexPathsForSelectedItems?
                        .map { Constants.interestsDataSource[$0.section][$0.item] }
            self.selectedInformations.accept(interests ?? [])
        }
    }
}
