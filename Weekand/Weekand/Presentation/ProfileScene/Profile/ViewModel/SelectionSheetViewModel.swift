//
//  SelectionSheetViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/23.
//

import Foundation
import RxSwift
import RxCocoa

class SelectionSheetViewModel: ViewModelType {
    
    enum InformationType: String {
        case job = "직업"
        case interests = "관심사"
    }
    
    weak var coordinator: ProfileCoordinator?
    private var disposeBag = DisposeBag()
    
    let informationType: InformationType

    init(coordinator: ProfileCoordinator, informationType: InformationType) {
        self.coordinator = coordinator
        self.informationType = informationType
    }
    
    struct Input {
        let selectedInformations: BehaviorRelay<[String]>
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
