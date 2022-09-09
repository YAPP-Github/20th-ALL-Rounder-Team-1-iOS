//
//  StickerAddSheetViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/07.
//

import UIKit
import RxSwift

enum StickerSection {
    case main
}

class StickerAddSheetViewModel: ViewModelType {

    let coordinator: MainCoordinator
    private let mainUseCase: MainUseCase
    private let disposeBag = DisposeBag()
    
    let id: String
    let date: Date
    var existingEmoji: Emoji?
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<StickerSection, Emoji>!
    let emojiList: [Emoji] = [.good, .awesome, .cool, .support]
    
    var stickerCreated = PublishSubject<Bool>()
    
    init(mainCoordinator: MainCoordinator, mainUseCase: MainUseCase, id: String, date: Date) {
        self.coordinator = mainCoordinator
        self.mainUseCase = mainUseCase
        self.id = id
        self.date = date
        
    }
    
    func configureCollectionViewSnapShot(animatingDifferences: Bool = false) {
        
        var snapshot = NSDiffableDataSourceSnapshot<StickerSection, Emoji>()
        snapshot.appendSections([.main])
        snapshot.appendItems(emojiList, toSection: .main)
        self.collectionViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func getExistingEmoji(completion: @escaping () -> Void) {
        self.myStickerAdded(id: self.id, date: self.date, completion: completion)
    }

}

extension StickerAddSheetViewModel {
    
    struct Input {
        let stickerSelected: Observable<Emoji>
    }
    
    struct Output {
        let stickerCreated: Observable<Bool>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.stickerSelected.subscribe(onNext: { emoji in
            self.createSticker(id: self.id, emoij: emoji, date: self.date) {
                self.coordinator.dismissStickerAddSheet()
            }
            
        }).disposed(by: disposeBag)
        
        return Output(stickerCreated: stickerCreated.asObservable())
    }
}

extension StickerAddSheetViewModel {
    
    func myStickerAdded(id: String, date: Date, completion: @escaping () -> Void) {
        
        self.mainUseCase.myStickerAdded(id: id, data: date).subscribe(onSuccess: { emoji in
            
            self.existingEmoji = emoji
            completion()
            
        }, onFailure: { error in
            
            self.existingEmoji = nil
            completion()
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)    }
    
    /// 스티커 추가
    func createSticker(id: String, emoij: Emoji, date: Date, completion: @escaping () -> Void) {
        self.mainUseCase.createSticker(id: id, sticker: emoij, date: date).subscribe(onSuccess: { success in
            PublishSubject<Bool>.just(success).bind(to: self.stickerCreated).disposed(by: self.disposeBag)
            completion()

        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
}
