//
//  SearchUseCase.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/19.
//

import Foundation
import RxSwift

final class SearchUseCase {
    func SearchUsers(searchQuery: String, jobs: [String], interests: [String], sort: UserSort, page: Int, size: Int)
    -> Single<SearchUsersQuery.Data.SearchUser> {
                NetWork.shared.fetch(query: SearchUsersQuery(searchQuery: searchQuery, jobs: jobs, interests: interests, sort: sort.toModel(), page: page, size: size))
            .map { $0.searchUsers }
            .asSingle()
        }
}
