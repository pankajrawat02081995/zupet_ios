//
//  ProfileModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 30/08/25.
//

import Foundation

// MARK: - ProfileResponse
struct ProfileModel: Codable {
    let success: Bool
    let message : String?
    let data: UserProfile?
}

// MARK: - UserProfile
struct UserProfile: Codable {
    let id: String?
    let fullName: String?
    let avatar: String?
    let email: String?
    let phone: String?
    let countryCode: String?
    let petsCount: Int?
    let journey: [Journey]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case fullName, avatar, email, phone, countryCode, petsCount, journey
    }
}

// MARK: - Journey
struct Journey: Codable {
    let title: String?
    let value: String?
}
