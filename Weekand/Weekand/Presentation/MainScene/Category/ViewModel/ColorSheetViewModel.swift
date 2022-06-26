//
//  ColorBottomSheetViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/25.
//

import Foundation
import RxSwift
import RxCocoa

class ColorSheetViewModel: ViewModelType {
    
    weak var coordinator: CategoryAddCoordinator?
    
    let colors = [[Color(id: 1, hexCode: "#FF9292"),
                   Color(id: 2, hexCode: "#FFB27A"),
                   Color(id: 3, hexCode: "#FFE600"),
                   Color(id: 4, hexCode: "#94EB9C"),
                   Color(id: 5, hexCode: "#67DBFF"),
                   Color(id: 6, hexCode: "#83A5FF"),
                   Color(id: 7, hexCode: "#C081FF")],
                  [Color(id: 8, hexCode: "#FFA6A6"),
                   Color(id: 9, hexCode: "#FFC59B"),
                   Color(id: 10, hexCode: "#FFF278"),
                   Color(id: 11, hexCode: "#B6EEBC"),
                   Color(id: 12, hexCode: "#A6EAFF"),
                   Color(id: 13, hexCode: "#B1C7FF"),
                   Color(id: 14, hexCode: "#D4AAFF")],
                  [Color(id: 15, hexCode: "#FFC8C8"),
                   Color(id: 16, hexCode: "#FFDEC7"),
                   Color(id: 17, hexCode: "#FFF7AC"),
                   Color(id: 18, hexCode: "#D8F5DB"),
                   Color(id: 19, hexCode: "#CFF3FF"),
                   Color(id: 20, hexCode: "#D8E3FF"),
                   Color(id: 21, hexCode: "#E9D3FF")]]

    init(coordinator: CategoryAddCoordinator) {
        
        self.coordinator = coordinator
    }
    
    struct Input {
        let didColorCellSelected: Observable<IndexPath>
        let didTapConfirmButton: Observable<Void>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        return Output()
    }

}
