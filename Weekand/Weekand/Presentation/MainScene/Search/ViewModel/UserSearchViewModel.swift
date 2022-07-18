//
//  UserSearchViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/15.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class UserSearchViewModel: ViewModelType {
    
    weak var coordinator: UserSearchCoordinator?
    private var disposeBag = DisposeBag()
    
    var hasNext: Bool = false
    
    init(coordinator: UserSearchCoordinator) {
        self.coordinator = coordinator
    }

}

// MARK: Bind UI
extension UserSearchViewModel {
    
    struct Input {
        let didTapJobFilterButton: Observable<Void>
        let didTapInterestsFilterButton: Observable<Void>
        let didEditSearchBar: Observable<String>
        let selectedJobs: BehaviorRelay<[Any]>
        let selectedInterests: BehaviorRelay<[Any]>
    }
    
    struct Output {
        var searchAction: Observable<(Observable<String>.Element, Observable<([Any], [Any])>.Element)>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        let searchBarEdit = input.didEditSearchBar
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
        
        let informationEdit = Observable.combineLatest(input.selectedJobs, input.selectedInterests)
        
        input.didTapJobFilterButton.subscribe(onNext: {
            self.coordinator?.presentJobInformationSheet()
        })
        .disposed(by: disposeBag)
        
        input.didTapInterestsFilterButton.subscribe(onNext: {
            self.coordinator?.presentInterestsInformationSheet()
        })
        .disposed(by: disposeBag)
        
        return Output(searchAction: Observable.combineLatest(searchBarEdit, informationEdit))
    }
}
