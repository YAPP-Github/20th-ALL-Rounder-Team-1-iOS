//
//  Constants.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/18.
//

import Foundation

struct Constants {
    static let jobDataSource = [["학생", "취준생", "직장인", "프리랜서"],
                                ["경영", "사무", "마케팅", "IT", "디자인"],
                                ["무역", "유통", "영업", "서비스", "연구원"],
                                ["제조", "관광", "교육", "건설", "의료"],
                                ["연예", "미디어", "전문직", "특수직"],
                                ["사업", "주부"]]
    
    static let interestsDataSource = [["N잡", "이직", "구직", "스터디", "연구"],
                                        ["기획", "마케팅", "디자인", "개발"],
                                        ["외국어", "SNS", "사업", "경제"],
                                        ["반려동물", "봉사", "자기계발", "문화생활"],
                                        ["영화", "음악", "독서", "글쓰기", "게임"],
                                        ["운동", "여행"]]
    
    static let colors = [[Color(id: 1, hexCode: "#ff9292"),
                   Color(id: 2, hexCode: "#ffB27A"),
                   Color(id: 3, hexCode: "#ffe600"),
                   Color(id: 4, hexCode: "#94eb9C"),
                   Color(id: 5, hexCode: "#67dbff"),
                   Color(id: 6, hexCode: "#83a5ff"),
                   Color(id: 7, hexCode: "#c081ff")],
                  [Color(id: 8, hexCode: "#ffa6a6"),
                   Color(id: 9, hexCode: "#ffc59b"),
                   Color(id: 10, hexCode: "#fff278"),
                   Color(id: 11, hexCode: "#b6eebc"),
                   Color(id: 12, hexCode: "#a6eaff"),
                   Color(id: 13, hexCode: "#b1c7ff"),
                   Color(id: 14, hexCode: "#d4aaff")],
                  [Color(id: 15, hexCode: "#ffc8c8"),
                   Color(id: 16, hexCode: "#ffdec7"),
                   Color(id: 17, hexCode: "#fff7ac"),
                   Color(id: 18, hexCode: "#d8f5db"),
                   Color(id: 19, hexCode: "#cff3ff"),
                   Color(id: 20, hexCode: "#d8e3ff"),
                   Color(id: 21, hexCode: "#e9d3ff")]]
}

extension Constants {
    static func convertJobToIndexPath(_ text: String) -> IndexPath {
        var indexPath = IndexPath(item: 0, section: 0)
        for section in 0..<Constants.jobDataSource.count {
            for item in 0..<Constants.jobDataSource[section].count {
                if Constants.jobDataSource[section][item] == text {
                    indexPath = IndexPath(item: item, section: section)
                }
            }
        }
        return indexPath
    }
    
    static func convertInterestsToIndexPath(_ text: String) -> IndexPath {
        var indexPath = IndexPath(item: 0, section: 0)
        for section in 0..<Constants.interestsDataSource.count {
            for item in 0..<Constants.interestsDataSource[section].count {
                if Constants.interestsDataSource[section][item] == text {
                    indexPath = IndexPath(item: item, section: section)
                }
            }
        }
        return indexPath
    }
}
