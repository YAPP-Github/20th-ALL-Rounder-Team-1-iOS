//
//  CategoryListViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/14.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class CategoryListViewModel {
    
    weak var coordinator: CategoryCoordinator?
    private let categoryUseCase: CategoryUseCase
    private var disposeBag = DisposeBag()
    
    let categoryList = PublishRelay<[Category]>()
    var hasNext: Bool = false
    
    init(coordinator: CategoryCoordinator, categoryUseCase: CategoryUseCase) {
        self.coordinator = coordinator
        self.categoryUseCase = categoryUseCase
    }

}

// MARK: Bind UI
extension CategoryListViewModel {
    
    struct Input {
        let didTapAddCategoryButton: Observable<Void>
        let categoryCellDidSelected: PublishRelay<Category>
        let categoryCellDidSwipeEvent: PublishRelay<Category>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.didTapAddCategoryButton.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.showCategoryAddScene()
        }).disposed(by: disposeBag)
        
        input.categoryCellDidSelected.subscribe(onNext: { [weak self] category in
            self?.coordinator?.pushCategoryDetailViewController(category: category)
        }).disposed(by: disposeBag)
        
        input.categoryCellDidSwipeEvent.subscribe(onNext: { [weak self] category in
            self?.coordinator?.showCategoryModifyScene(category: category)
        }).disposed(by: disposeBag)
        
        return Output()
    }
}

extension CategoryListViewModel {
    func searchCategories(sort: ScheduleSort, page: Int, size: Int) {
        
        self.categoryUseCase.ScheduleCategories(sort: sort, page: page, size: size)
            .subscribe(onSuccess: { data in
                self.hasNext = data.paginationInfo.hasNext
                let list = data.scheduleCategories.map { category in
                    Category(serverID: category.id, color: category.color, name: category.name, openType: category.openType.toEntity())
                }
                self.categoryList.accept(list)
            }, onFailure: { error in
                print(error)
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func loadMoreCategoryList(selectedSort: ScheduleSort, page: Int, size: Int) {
        if hasNext {
            self.searchCategories(sort: selectedSort, page: page, size: size)
        }
    }
    
    func deleteCategory(id: String, completion: @escaping () -> Void) {
        self.categoryUseCase.deleteCategory(id: id)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed {
                    completion()
                } else {
                    self.coordinator?.showToastMessage(text: "일정 삭제에 실패하였습니다.")
                }
            }, onFailure: { error in
                if error.localizedDescription == CategoryError.minimumCategoryCount.localizedDescription {
                    self.coordinator?.showToastMessage(text: error.localizedDescription)
                } else {
                    self.coordinator?.showToastMessage(text: "일정 삭제에 실패하였습니다.")
                }
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
}
