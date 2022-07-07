//
//  StickerAddSheetViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/07.
//

import UIKit

enum EmojiSection {
    case main
}

class StickerAddSheetViewModel {
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<EmojiSection, Emoji>!
    
    let emojiList: [Emoji] = [.good, .awesome, .cool, .support]
    
    func configureCollectionViewSnapShot(animatingDifferences: Bool = false) {
        
        var snapshot = NSDiffableDataSourceSnapshot<EmojiSection, Emoji>()
        snapshot.appendSections([.main])
        snapshot.appendItems(emojiList, toSection: .main)
        self.collectionViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

}
