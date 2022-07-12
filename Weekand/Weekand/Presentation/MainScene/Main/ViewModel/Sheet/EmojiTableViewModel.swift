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
    
    let sampleData = [
        EmojiGiver(userId: "0", name: "dafd", imagePath: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60", emoji: .good),
        EmojiGiver(userId: "0", name: "dafd", imagePath: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60", emoji: .awesome),
        EmojiGiver(userId: "0", name: "dafd", imagePath: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60", emoji: .good),
        EmojiGiver(userId: "0", name: "dafd", imagePath: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60", emoji: .support),
        EmojiGiver(userId: "0", name: "dafd", imagePath: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60", emoji: .good)
    ]
    
    let disposeBag = DisposeBag()

    var tableViewDataSource: UITableViewDiffableDataSource<EmojiSection, EmojiGiver>!
    
    private var targetEmojiList = BehaviorRelay<[EmojiGiver]>(value: [])
    
    init(emoji: Emoji?) {
        BehaviorRelay<[EmojiGiver]>.just(sampleData).bind(to: targetEmojiList).disposed(by: disposeBag)
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
