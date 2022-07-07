//
//  StickerAddSheet.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/07.
//

import UIKit
import RxSwift

class StickerAddSheetViewController: BottomSheetViewController {
    
    var viewModel: StickerAddSheetViewModel?
    let disposeBag = DisposeBag()
    
    // MARK: UI Properties
    lazy var titleLabel = UILabel().then {
        $0.text = "친구의 일정에 스티커를 붙여보세요"
        $0.font = WFont.head2()
    }
    
    var collectionView: UICollectionView!
    
    override var bottomSheetHeight: CGFloat {
        get {
            return 450
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
    }
    
    private func setUpView() {
        configureCollectionView()
    }
    
    private func configureUI() {
        [titleLabel].forEach { self.bottomSheetView.addSubview($0) }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(43)
            make.left.right.equalToSuperview().inset(24)
        }
    }
    
}

// MARK: CollectionView DataSource
extension StickerAddSheetViewController {
    
    private func configureCollectionView() {
        setUpCollectionView()
        configureCollectionViewDataSource()
    }
    
    private func setUpCollectionView() {
                
        let layout = UICollectionViewCompositionalLayout {
            (_: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
                        
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(40), heightDimension: .absolute(60))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(14), top: nil, trailing: .fixed(14), bottom: nil)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(0), heightDimension: .absolute(60)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = .init(top: 12, leading: 10, bottom: 12, trailing: 24)

            return section
        }
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0), collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
    }
    
    private func configureCollectionViewDataSource() {
        
        viewModel?.collectionViewDataSource = UICollectionViewDiffableDataSource<MainSection, FollowingUser>(collectionView: collectionView, cellProvider: { collectionView, indexPath, list in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
            cell.setUpCell(list)
            
            if indexPath.item == 0 {
                self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            }
            
            return cell
        })
        
        viewModel?.configureCollectionViewSnapShot()
    }
    
}
