//
//  OwnPetModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 30/08/25.
//

import Foundation

// MARK: - PetsResponse
struct OwnPetModel: Codable {
    let success: Bool?
    let message : String?
    let data: [PetData]?
}

// MARK: - Pet
struct PetData: Codable {
    let id: String?
    let name: String?
    let species: String?
    let breed: String?
    let color: String?
    let mood: String?
    let noseId: String?
    let weight: Int?
    let height: PetHeight?
    let country: String?
    let avatar: String?
    let location: Location?
    let user: String?
    let status: Bool?
    let createdAt: String?
    let updatedAt: String?
    let v: Int?
    let dob: String?
    let recentActivity: [RecentActivity]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, species, breed, color, mood, noseId, weight, height, country, avatar, location, user, status, createdAt, updatedAt, dob, recentActivity
        case v = "__v"
    }
}


// MARK: - Location
struct Location: Codable {
    let `default`: DefaultLocation?
    let type: String?
    let coordinates: [Double]?
}

// MARK: - DefaultLocation
struct DefaultLocation: Codable {
    let coordinates: [Double]?
}
