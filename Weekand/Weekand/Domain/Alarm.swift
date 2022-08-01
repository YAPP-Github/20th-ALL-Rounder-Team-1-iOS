//
//  Alarm.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/29.
//

import Foundation

struct Alarm: Hashable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
      lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(uuid)
    }

    let uuid = UUID()
    let id: String
    let message: String
    let type: String
}

extension Alarm {
    init (model: NotificationQuery.Data.Notification.Notification) {
        
        self.id = model.id
        self.message = model.message
        self.type = model.type.rawValue
    }
}
