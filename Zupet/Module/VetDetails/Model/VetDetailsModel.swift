//
//  VetDetailsModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 02/09/25.
//

import Foundation

// MARK: - Root Response
struct VetDetailsModel: Codable {
    let success: Bool?
    let message : String?
    let data: VetDetailsData?
}

// MARK: - Place Data
struct VetDetailsData: Codable {
    let id: String?
    let name: String?
    let aboutPlace: String?
    let address: String?
    let city: String?
    let state: String?
    let postalcode: String?
    let country: String?
    let phone: String?
    let email: String?
    let placeId: String?
    let source: String?
    let website: String?
    let totalReviews: Int?
    let rating: Double?
    let categories: [String]?
    let services: [Service]?
    let accessibility: [String]?
    let amenities: [String]?
    let reviews: [Review]?
    let reviewBreakdown: [String: Int]?
    let photos: [String]?
    let videos: [String]?
    let faq: [String]?
    let Vetlocation: Vetlocation?
    let status: Bool?
    let v: Int?
    let createdAt: String?
    let updatedAt: String?
    let officeTiming: [OfficeTiming]?
    let weekdayDescriptions: [String]?
    let openingTime: String?
    let closingTime: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, aboutPlace, address, city, state, postalcode, country, phone, email, placeId, source, website, totalReviews, rating, categories, services, accessibility, amenities, reviews, reviewBreakdown, photos, videos, faq, status
        case v = "__v"
        case Vetlocation = "location"
        case createdAt, updatedAt, officeTiming, weekdayDescriptions, openingTime, closingTime
    }
}

// MARK: - Service
struct Service: Codable {
    let name: String?
    let icon: String?
}

// MARK: - Review
struct Review: Codable {
    let authorName: String?
    let rating: Double?
    let text: String?
    let profilePhotoUrl: String?
    let relativeTimeDescription: String?
    let photos: [String]?
    let time: Int64? // timestamp in milliseconds

    // Computed property: returns "time ago" string
    var timeAgo: String? {
        guard let millis = time else { return nil }
        let date = Date(timeIntervalSince1970: TimeInterval(millis) / 1000)
        return date.timeAgoDisplay()
    }
}


// MARK: - Location
struct Vetlocation: Codable {
    let type: String?
    let coordinates: [Double]?
}

// MARK: - Office Timing
struct OfficeTiming: Codable {
    let open: OfficeTime?
    let close: OfficeTime?
}

struct OfficeTime: Codable {
    let day: Int?
    let hour: Int?
    let minute: Int?
}
