//
//  ViewModelType.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/01.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
