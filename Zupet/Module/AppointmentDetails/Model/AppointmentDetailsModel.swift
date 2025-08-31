//
//  AppointmentDetailsModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 31/08/25.
//

import Foundation

// MARK: - Root Model
struct AppointmentDetailsModel: Codable {
    let success: Bool?
    let message: String?
    var data: AppointmentData?
}

// MARK: - Appointment Data
struct AppointmentData: Codable {
    let id: String?
    let user: User?
    let vet: Vet?
    let specialNotes: String?
    let date: String?
    let time: String?
    let status: String?
    let createdAt: String?
    let updatedAt: String?
    var timeline: [Timeline]?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user, vet, specialNotes, date, time, status, createdAt, updatedAt, timeline
        case v = "__v"
    }
}

// MARK: - User
struct User: Codable {
    let id: String?
    let fullName: String?
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case fullName, avatar
    }
}


// MARK: - Timeline
struct Timeline: Codable {
    let stage: String?
    let title: String?
    let message: String?
    let actor: String?
    var requiresAction: Bool?
    let alternateSlots: [String]?
    let clinicBooking: ClinicBooking?
    let userResponse: UserResponse?
    let id: String?
    let timestamp: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case stage, title, message, actor, requiresAction, alternateSlots, clinicBooking, userResponse, timestamp, image
        case id = "_id"
    }
}

