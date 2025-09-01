//
//  PetNoseScanerModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 01/09/25.
//

import Foundation

struct PetNoseScanerModel: Codable {
    let success: Bool?
    let message : String?
    let data: PetNoseScanerData?
    
    enum CodingKeys: String, CodingKey {
        case success
        case data
        case message
    }
}

struct PetNoseScanerData: Codable {
    let petType: String?
    let breed: String?
    let mood: String?
    let image: String?
}
