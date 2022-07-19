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
    var searchUseCase: SearchUseCase
    private var disposeBag = DisposeBag()
    
    var hasNext: Bool = false
    
    let userList = PublishRelay<[UserSummaryTemp]>()
    
    init(coordinator: UserSearchCoordinator, searchUseCase: SearchUseCase) {
        self.coordinator = coordinator
        self.searchUseCase = searchUseCase
    }

}

// MARK: Bind UI
extension UserSearchViewModel {
    
    struct Input {
        let didTapJobFilterButton: Observable<Void>
        let didTapInterestsFilterButton: Observable<Void>
        let didEditSearchBar: Observable<String>
        let didTapSearchButton: Observable<Void>
        let selectedJobs: BehaviorRelay<[String]>
        let selectedInterests: BehaviorRelay<[String]>
    }
    
    struct Output {
        var searchWithInformation: Observable<([String], [String])>
        var searchWithQueryInformation: Observable<([String], [String])>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        let informationEdit = Observable.combineLatest(input.selectedJobs, input.selectedInterests)
        
        let searchWithQueryInformation = input.didTapSearchButton.withLatestFrom(informationEdit)
        
        input.didTapJobFilterButton.subscribe(onNext: {
            self.coordinator?.presentJobInformationSheet()
        })
        .disposed(by: disposeBag)
        
        input.didTapInterestsFilterButton.subscribe(onNext: {
            self.coordinator?.presentInterestsInformationSheet()
        })
        .disposed(by: disposeBag)
        
        return Output(searchWithInformation: informationEdit, searchWithQueryInformation: searchWithQueryInformation)
    }
    
    func searchUsers(searchQuery: String, jobs: [String], interests: [String], sort: UserSort, page: Int, size: Int) {
        
        self.searchUseCase.SearchUsers(searchQuery: searchQuery, jobs: jobs, interests: interests, sort: sort, page: page, size: size)
            .subscribe(onSuccess: { data in
                self.hasNext = data.paginationInfo.hasNext
                let list = data.users.map { user in
                    
                    UserSummaryTemp(userSummaryId: user.id, name: user.nickname, goal: user.goal ?? "", imagePath: user.profileUrl)
                }
                self.userList.accept(list)
            }, onFailure: { error in
                print(error)
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func loadMoreUserList(searchQuery: String, jobs: [String], interests: [String], sort: UserSort, page: Int, size: Int) {
        if hasNext {
            self.searchUsers(searchQuery: searchQuery, jobs: jobs, interests: interests, sort: sort, page: page, size: size)
        }
    }
}
