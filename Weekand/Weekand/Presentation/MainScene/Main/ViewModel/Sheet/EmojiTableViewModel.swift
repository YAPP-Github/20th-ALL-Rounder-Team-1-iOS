//
//  EmojiTableViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/07.
//


import UIKit
import RxSwift
import RxRelay

enum EmojiSection {
    case main
}

class EmojiTableViewModel {
    
    let targetEmoji: Emoji?
    
    let disposeBag = DisposeBag()

    var tableViewDataSource: UITableViewDiffableDataSource<EmojiSection, EmojiGiver>!
    var targetEmojiList = BehaviorRelay<[EmojiGiver]>(value: [])
    
    init(emoji: Emoji?, list: [EmojiGiver]) {
        BehaviorRelay<[EmojiGiver]>.just(list).bind(to: targetEmojiList).disposed(by: disposeBag)
        targetEmoji = emoji
    }

}

// MARK: Diffable Data Source
extension EmojiTableViewModel {
    
    func configureTableViewSnapshot(animatingDifferences: Bool = true) {
        
        self.targetEmojiList.subscribe(onNext: { data in
            
            var list = data
            if let emoji = self.targetEmoji {
                list = data.filter { $0.emoji == emoji }
            }
            
            var snapshot = NSDiffableDataSourceSnapshot<EmojiSection, EmojiGiver>()
            snapshot.appendSections([.main])
            snapshot.appendItems(list, toSection: .main)
            self.tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }).disposed(by: self.disposeBag)
    }

}
