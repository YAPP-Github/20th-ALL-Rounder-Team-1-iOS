//
//  EmojiTabViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/28.
//

import Foundation
import RxSwift

class EmojiTabViewModel {
  
    private let mainUseCase: MainUseCase
    private let disposeBag = DisposeBag()
    
    init() {
        mainUseCase = MainUseCase()
    }
    
}

extension EmojiTabViewModel {
    
    func getStickerSummary(id: String, date: Date) {
        self.mainUseCase.stickerSummary(id: id, date: date).subscribe(onSuccess: { scheduleData in
            
            

        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)

    }
}

