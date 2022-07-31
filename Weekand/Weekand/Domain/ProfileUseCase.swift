//
//  ProfileUseCase.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/22.
//

import Foundation
import RxSwift

final class ProfileUseCase {
    
    /// 유저 상세 프로필 불러오기
    func profileDetail(id: String?) -> Single<UserDetail> {
        return NetWork.shared.fetch(query: UserDetailQuery(id: id), cachePolicy: .fetchIgnoringCacheCompletely)
            .map {
                if let userData = $0.user {
                    return UserDetail(model: userData)
                } else {
                    return UserDetail.defaultData
                }
                
            }.asSingle()
    }
    
    /// S3 서버에 전송할 이미지 (Url, filename) 반환
    func createImageUrl(type: ImageExtensionType) -> Single<(String, String)> {
        
        return NetWork.shared.perform(mutation: CreateImageUrlMutation(type: UserProfileImageExtensionType(rawValue: type.rawValue) ?? .png))
            .map { ($0.createUserProfileImageS3PresignedUrl.url, $0.createUserProfileImageS3PresignedUrl.filename) }
            .asSingle()
    }
    
    /// 유저 업데이트
    func updateProfile(data: UserUpdate) -> Single<UserDetail> {
        return NetWork.shared.perform(mutation: UpdateUserDetailMutation(imageName: data.imageFileName ?? "", nickname: data.name!, goal: data.goal!, jobs: data.job, interests: data.interest))
            .map {
                let data = $0.updateUserProfile
                return UserDetail(userId: data.id, email: data.email, name: data.nickname, goal: data.goal ?? "", imagePath: data.profileImageUrl, followee: data.followeeCount, follower: data.followerCount, job: data.jobs, interest: data.interests, followed: data.followed)
            }.asSingle()
    }
    
    /// 유저 팔로우하기
    func createFollowee(id: String) -> Single<Bool> {
        return NetWork.shared.perform(mutation: CreateFolloweeMutation(id: id))
            .map { $0.createFollow }
            .asSingle()
    }
    
    /// 유저 팔로우 취소하기
    func deleteFollowee(id: String) -> Single<Bool> {
        return NetWork.shared.perform(mutation: DeleteFolloweeMutation(id: id))
            .map { $0.deleteFollowee }
            .asSingle()
    }
    
    /// 문의 내용 전송
    func sendContact(message: String) -> Single<Bool> {
        return NetWork.shared.perform(mutation: SendContactMutation(message: message))
            .map { $0.inquiry }
            .asSingle()
    }
 
    /// 비밀번호 변경
    func updatePassword(old: String, new: String) -> Single<Bool> {
        return NetWork.shared.perform(mutation: UpdatePasswordMutation(old: old, new: new))
            .map { $0.updatePassword }
            .asSingle()
    }
    
    /// 로그아웃 하기
    func logout() -> Single<Bool> {
        return NetWork.shared.perform(mutation: LogoutMutation())
            .map { $0.logout }
            .asSingle()
    }
    
    /// 탈퇴 하기
    func deleteUser() -> Single<Bool> {
        return NetWork.shared.perform(mutation: DeleteUserMutation())
            .map { $0.deleteUser }
            .asSingle()
    }
    
    /// 특정 유저의 팔로잉 목록
    func userFollowees(id: String, page: Int, size: Int) -> Single<[FollowingUser]> {
        return NetWork.shared.fetch(query: UserFolloweesQuery(id: id, page: page, size: size), cachePolicy: .fetchIgnoringCacheCompletely)
            .map {
                $0.followees.followees.map { FollowingUser(model: $0) }
            }.asSingle()
    }
    
    /// 특정 유저의 팔로워 목록
    func userFollowers(id: String, page: Int, size: Int) -> Single<[FollowingUser]> {
        return NetWork.shared.fetch(query: UserFollowersQuery(id: id, page: page, size: size), cachePolicy: .fetchIgnoringCacheCompletely)
            .map {
                $0.followers.followers.map { FollowingUser(model: $0) }
            }.asSingle()
    }

    
}

