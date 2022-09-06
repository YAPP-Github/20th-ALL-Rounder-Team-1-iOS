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
    var targetEmojiList: [EmojiGiver]
    
    init(emoji: Emoji?, list: [EmojiGiver]) {
        targetEmojiList = list
        targetEmoji = emoji
    }

}

// MARK: Diffable Data Source
extension EmojiTableViewModel {
    
    func configureTableViewSnapshot(animatingDifferences: Bool = false) {
        
        var list = targetEmojiList
        if let emoji = self.targetEmoji {
            list = targetEmojiList.filter { $0.emoji == emoji }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<EmojiSection, EmojiGiver>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        self.tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

}
