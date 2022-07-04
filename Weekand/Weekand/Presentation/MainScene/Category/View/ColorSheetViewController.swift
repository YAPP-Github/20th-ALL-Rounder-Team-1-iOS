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
    
    var colorsCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Color>!
    
    // ViewMoel
    
    private let disposeBag = DisposeBag()
    var viewModel: ColorSheetViewModel?
    
    // SheetHeight
    
    override var bottomSheetHeight: CGFloat {
        get {
            return 330
        }
    }
    
    // Views
    
    lazy var sheetTitle = WTextLabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray900
        $0.text = "색상"
    }
    
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
                        
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(36), heightDimension: .absolute(36))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(5), top: nil, trailing: .fixed(5), bottom: nil)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = .init(top: 8, leading: 0, bottom: 8, trailing: 0)

            return section
        }
        
        self.colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.colorsCollectionView.delegate = self
        self.colorsCollectionView.isScrollEnabled = false
        self.colorsCollectionView.allowsMultipleSelection = false
        self.colorsCollectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: ColorsCollectionViewCell.cellIdentifier)
    }
    
    private func configureUI() {
        bottomSheetView.addSubview(sheetTitle)
        sheetTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(24)
        }
        
        bottomSheetView.addSubview(colorsCollectionView)
        colorsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sheetTitle.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(200)
        }
        
        bottomSheetView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-40)
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

import SwiftUI
#if canImport(SwiftUI) && DEBUG

struct ColorSheetViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ColorSheetViewController().showPreview(.iPhone11Pro)
        }
    }
}
#endif
