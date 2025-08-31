//
//  AppointmentModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 30/08/25.
//

import Foundation

// MARK: - AppointmentResponse
struct AppointmentModel: Codable {
    let success: Bool?
    let message: String?
    let data: [Appointment]?
}

// MARK: - Appointment
struct Appointment: Codable {
    let id: String?
    let user: String?
    let vet: Vet?
    let specialNotes: String?
    let date: String?
    let time: String?
    let status: String?
    let createdAt: String?
    let updatedAt: String?
    let timeline: [Timeline]?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user, vet, specialNotes, date, time, status, createdAt, updatedAt, timeline
        case v = "__v"
    }
}

// MARK: - Vet
struct Vet: Codable {
    let id: String?
    let name: String?
    let address: String?
    let categories: [String]?
    let services: [String]?
    let photos: [String]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, address, categories, services, photos
    }
}

// MARK: - ClinicBooking
struct ClinicBooking: Codable {
    let clinicNotes: String?
}

// MARK: - UserResponse
struct UserResponse: Codable {
    let decision: String?
}
