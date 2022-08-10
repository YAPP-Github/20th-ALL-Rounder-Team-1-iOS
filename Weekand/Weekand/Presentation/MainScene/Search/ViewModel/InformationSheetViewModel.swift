//
//  InformationSheetViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/18.
//

import Foundation
import RxSwift
import RxCocoa

class InformationSheetViewModel: ViewModelType {
    
    enum InformationType: String {
        case job = "직업"
        case interests = "관심사"
    }
    
    weak var coordinator: UserSearchCoordinator?
    private var disposeBag = DisposeBag()
    
    let informationType: InformationType

    init(coordinator: UserSearchCoordinator, informationType: InformationType) {
        self.coordinator = coordinator
        self.informationType = informationType
    }
    
    struct Input {
        let selectedInformations: PublishRelay<[String]>
        let didTapConfirmButton: Observable<Void>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.didTapConfirmButton.withLatestFrom(input.selectedInformations).subscribe(onNext: { informations in
            if self.informationType == .job {
                self.coordinator?.setJobInformations(informations)
            } else {
                self.coordinator?.setInterestsInformations(informations)
            }
            self.coordinator?.navigationController.dismiss(animated: true)
        })
        .disposed(by: disposeBag)
        
        return Output()
    }

}
