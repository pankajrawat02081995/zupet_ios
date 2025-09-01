//
//  FindVetModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 01/09/25.
//

import Foundation

struct FindVetModel: Codable {
    let success: Bool?
    let message : String?
    let data: [Hospital]?
}

struct Hospital: Codable {
    let id: String?
    let name: String?
    let address: String?
    let photos: [String]?
    let rating: Double?
    let totalReviews: Int?
    let closingTime: String?
    let openingTime: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, address, photos, rating, totalReviews, closingTime, openingTime
    }
}
