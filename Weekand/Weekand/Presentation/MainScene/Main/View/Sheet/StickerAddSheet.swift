//
//  StickerAddSheet.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/07.
//

import UIKit
import RxSwift

/// 스티커 추가
class StickerAddSheetViewController: BottomSheetViewController {
    
    var viewModel: StickerAddSheetViewModel?
    let disposeBag = DisposeBag()
    
    var selectedEmoji = PublishSubject<Emoji>()
    
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
        
        self.viewModel?.getExistingEmoji {
            self.setUpView()
            self.configureUI()
            self.bindViewModel()
        }
    }
    
    private func setUpView() {
        configureCollectionView()
    }
    
    private func configureUI() {
        [titleLabel, collectionView].forEach { self.bottomSheetView.addSubview($0) }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(43)
            make.left.right.equalToSuperview().inset(24)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.bottom.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(375)
        }
    }
    
    private func bindViewModel() {
        
        let input = StickerAddSheetViewModel.Input(stickerSelected: selectedEmoji.asObservable())
        
        let output = viewModel?.transform(input: input)
        
        output?.stickerCreated.subscribe(onNext: { created in
            
            if created {
                self.dismiss(animated: true)
            } else {
                self.showToast(message: "스티커 추가를 실패했습니다.")
            }
            
        }).disposed(by: disposeBag)
    }
    
}

// MARK: CollectionView DataSource
extension StickerAddSheetViewController {
    
    private func configureCollectionView() {
        setUpCollectionView()
        configureCollectionViewDataSource()
    }
    
    private func setUpCollectionView() {
                
        let layout = UICollectionViewCompositionalLayout { (_: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
                        
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(130))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(28), top: nil, trailing: .fixed(28), bottom: nil)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 30, bottom: 0, trailing: 30)

            return section
        }
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0), collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = true
        collectionView.backgroundColor = .clear
        collectionView.register(StickerCollectionViewCell.self, forCellWithReuseIdentifier: StickerCollectionViewCell.identifier)
        
        collectionView.delegate = self
    }
    
    private func configureCollectionViewDataSource() {
        
        viewModel?.collectionViewDataSource = UICollectionViewDiffableDataSource<StickerSection, Emoji>(collectionView: collectionView, cellProvider: { collectionView, indexPath, emoji in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerCollectionViewCell.identifier, for: indexPath) as? StickerCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setUpCell(emoji: emoji)

            
            if let existingEmoji = self.viewModel?.existingEmoji {
                if existingEmoji == emoji {
                    self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
                }
            }
            
            return cell
        })
        
        viewModel?.configureCollectionViewSnapShot()
    }
    
}

extension StickerAddSheetViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        guard let emoji = self.viewModel?.emojiList[indexPath.item] else { return }
        PublishSubject<Emoji>.just(emoji).bind(to: selectedEmoji).disposed(by: disposeBag)
        
    }
}
