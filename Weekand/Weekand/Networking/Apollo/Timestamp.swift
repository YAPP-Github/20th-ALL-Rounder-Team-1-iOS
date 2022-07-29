//
//  Timestamp.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/20.
//

import Foundation
import Apollo

public typealias Timestamp = Int64

extension Timestamp: JSONDecodable, JSONEncodable {
    
    public var jsonValue: JSONValue {
        return Int64(self)
    }
    
    public init(jsonValue value: JSONValue) throws {

        guard let timestamp = value as? Int64 else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Date.self)
        }

        self = Int64(timestamp)
    }
    
}
