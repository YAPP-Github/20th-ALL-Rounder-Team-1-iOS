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
    
    static let colors = [[Color(id: 1, hexCode: "#FF9292"),
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
}
