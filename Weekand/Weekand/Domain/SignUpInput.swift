//
//  User.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/10.
//

import Foundation

struct SignUpInput {
    var email: String? = nil
    var password: String? = nil
    var nickname: String? = nil
    var jobs: [String]? = nil
    var interests: [String]? = nil
    var signUpAgreed: Bool? = nil
}
