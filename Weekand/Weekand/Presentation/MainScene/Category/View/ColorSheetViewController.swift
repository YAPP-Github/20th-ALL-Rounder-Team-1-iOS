//
//  ColorSheetViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

class ColorSheetViewController: BottomSheetViewController, UICollectionViewDelegate {
    
    // CollectionView
    
    enum Section {
      case first, second, third
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Color>!
    
    // ViewMoel
    
    private let disposeBag = DisposeBag()
    var viewModel: ColorSheetViewModel?
    
    // SheetHeight
    
    override var bottomSheetHeight: CGFloat {
        get {
            let screenHeight = UIScreen.main.bounds.height
            if screenHeight < 750 {
                return UIScreen.main.bounds.height * 0.44
            } else {
                return UIScreen.main.bounds.height * 0.37
            }
            
        }
    }
    
    // Views
    
    lazy var sheetTitle = WTextLabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray900
        $0.text = "색상"
    }
    
    lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    var colorsCollectionView: UICollectionView!
    
    lazy var confirmButton = WDefaultButton(title: "확인", style: .filled, font: WFont.subHead1())
    
    // stored property
    
    var selectedColor: Color = Constants.colors[0][0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        bindViewModel()
        configureDataSource()
        configureSnapshot()
    }
    
    private func setupView() {
        let layout = UICollectionViewCompositionalLayout { (_: Int,
            _ : NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let screenWidth = UIScreen.main.bounds.width
            let itemSize = screenWidth * 0.096
            let edgeSpacing = screenWidth * 0.013
            let sectionInset = screenWidth * 0.021
            let collectionLayoutSize = NSCollectionLayoutSize(
                                widthDimension: .absolute(itemSize),
                                heightDimension: .absolute(itemSize))
            let item = NSCollectionLayoutItem(layoutSize: collectionLayoutSize)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(edgeSpacing), top: nil, trailing: .fixed(edgeSpacing), bottom: nil)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = .init(top: sectionInset, leading: 0, bottom: sectionInset, trailing: 0)

            return section
        }
        
        self.colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.colorsCollectionView.delegate = self
        self.colorsCollectionView.isScrollEnabled = false
        self.colorsCollectionView.allowsMultipleSelection = false
        self.colorsCollectionView.backgroundColor = .clear
        self.colorsCollectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: ColorsCollectionViewCell.cellIdentifier)
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
        
        bottomSheetView.addSubview(colorsCollectionView)
        colorsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sheetTitle.snp.bottom).offset(screenHeight * 0.015)
            make.leading.equalToSuperview().offset(sideSpacing)
            make.trailing.equalToSuperview().offset(-sideSpacing)
            make.height.equalTo(screenHeight * 0.25)
        }
        
        bottomSheetView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(sideSpacing)
            make.trailing.equalToSuperview().offset(-sideSpacing)
            make.bottom.equalToSuperview().offset(-screenHeight * 0.04)
            make.height.equalTo(screenWidth * 0.12)
        }
    }
    
    private func bindViewModel() {
        let input = ColorSheetViewModel.Input(
            didColorCellSelected: self.colorsCollectionView.rx.itemSelected.asObservable(),
            didTapConfirmButton: self.confirmButton.rx.tap.asObservable()
        )
        
        self.confirmButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        self.viewModel?.transform(input: input)
    }

}

// MARK: CollectionView
extension ColorSheetViewController {
    
    private func configureDataSource() {
        let selectedIndexPath = NSIndexPath(item: selectedColor.id % 7 - 1, section: (selectedColor.id / 7) % 3)
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: self.colorsCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorsCollectionViewCell.cellIdentifier, for: indexPath) as? ColorsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(colorCode: itemIdentifier.hexCode)
            self.colorsCollectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .centeredHorizontally)
            return cell
        })
    }
    
    private func configureSnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Color>()
        snapshot.appendSections([.first])
        snapshot.appendItems((Constants.colors[0]), toSection: .first)
        snapshot.appendSections([.second])
        snapshot.appendItems((Constants.colors[1]), toSection: .second)
        snapshot.appendSections([.third])
        snapshot.appendItems((Constants.colors[2]), toSection: .third)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
