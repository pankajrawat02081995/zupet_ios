//
//  SigninModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 07/08/25.
//


import Foundation

struct SigninModel: Codable {
    let success: Bool?
    let message: String?
    let data: UserData?
}

struct UserData: Codable {
    let token: String?
    let id: String?
    let fullName: String?
    let avatar: String?
    let email: String?
    var petsCount : Int?

    enum CodingKeys: String, CodingKey {
        case token
        case petsCount
        case id = "_id"
        case fullName
        case avatar
        case email
    }
}
