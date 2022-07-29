//
//  String+extension.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/15.
//

import Foundation

extension String {
    var trimWhiteSpace: String {
        return self.trimmingCharacters(in: [" "])
    }
}
