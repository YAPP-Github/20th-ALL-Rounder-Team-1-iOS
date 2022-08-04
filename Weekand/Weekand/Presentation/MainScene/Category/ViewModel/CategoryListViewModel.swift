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

// MARK: Network
extension CategoryListViewModel {
    
    /// 카테고리 리스트
    func searchCategories(sort: ScheduleSort, page: Int, size: Int) {
        self.categoryUseCase.ScheduleCategories(sort: sort, page: page, size: size)
            .subscribe(onSuccess: { data in
                self.hasNext = data.paginationInfo.hasNext
                let list = data.scheduleCategories.map { category in
                    Category(serverID: category.id, color: category.color, name: category.name, openType: category.openType.toEntity())
                }
                self.categoryList.accept(list)
            }, onFailure: { _ in
                self.coordinator?.showToastMessage(text: "카테고리 리스트를 불러오지 못했습니다.")
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    /// 카테고리 리스트 pagination
    func loadMoreCategoryList(selectedSort: ScheduleSort, page: Int, size: Int) {
        if hasNext {
            self.searchCategories(sort: selectedSort, page: page, size: size)
        }
    }
    
    /// 카테고리 삭제
    func deleteCategory(id: String, completion: @escaping () -> Void) {
        self.categoryUseCase.deleteCategory(id: id)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed {
                    completion()
                } else {
                    self.coordinator?.showToastMessage(text: "카테고리 삭제에 실패하였습니다.")
                }
            }, onFailure: { error in
                if error.localizedDescription == CategoryError.minimumCategoryCount.serverDescription {
                    self.coordinator?.showToastMessage(text: "최소 1개 이상의 카테고리가 존재해야 합니다.")
                } else {
                    self.coordinator?.showToastMessage(text: "카테고리 삭제에 실패하였습니다.")
                }
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
}
