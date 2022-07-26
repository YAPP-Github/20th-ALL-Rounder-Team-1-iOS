//
//  Category.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/12.
//

import Foundation

struct Category: Hashable {
    
    static func == (lhs: Category, rhs: Category) -> Bool {
      lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }
    
    let identifier = UUID()
    let serverID: String
    let color: String
    let name: String
    let openType: CategoryOpenType
    
    init(serverID: String, color: String, name: String, openType: CategoryOpenType) {
        
        self.serverID = serverID
        self.color = color
        self.name = name
        self.openType = openType
    }
    
    init(model: ScehduleRuleQuery.Data.ScheduleRule.Category) {
        
        self.serverID = model.id
        self.color = model.color
        self.name = model.name
        self.openType = model.openType.toEntity()
    }
}
