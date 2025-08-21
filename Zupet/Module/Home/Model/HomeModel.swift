//
//  HomeModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 19/08/25.
//

import Foundation

struct HomeResponse: Codable {
    let success: Bool
    let message: String
    let data: [Section]
}

struct Section: Codable {
    let section: String
    let heading: Heading
    let data: SectionData
}

struct Heading: Codable {
    let title: String
    let icon: String?
}

/// Since `data` can be nested arrays, objects, or pets,
/// we need to decode it flexibly
enum SectionData: Codable {
    case nested([[SubSection]])
    case pet(Pet)
    case lostPets([LostPet])
    case empty
    case explore([Explore])
    case about([About])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Try Pet
        if let pet = try? container.decode(Pet.self) {
            self = .pet(pet)
            return
        }
        
        // Try LostPets
        if let lostPets = try? container.decode([LostPet].self) {
            self = .lostPets(lostPets)
            return
        }

        // Try Nested
        if let nested = try? container.decode([[SubSection]].self) {
            self = .nested(nested)
            return
        }
        
        // Try Explore
        if let explore = try? container.decode([Explore].self) {
            self = .explore(explore)
            return
        }

        // Try About
        if let about = try? container.decode([About].self) {
            self = .about(about)
            return
        }

        self = .empty
    }
}

struct SubSection: Codable {
    let section: String
    let heading: Heading
    let data: SectionData
}

struct Pet: Codable {
    let id: String
    let name: String
    let avatar: String?
    let species: String?
    let breed: String?
    let color: String?
    let age: Int?
    let mood: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, avatar, species, breed, color, age, mood
    }
}

struct LostPet: Codable {
    let id: String
    let pet: PetLost
    let user: User?
    let description: String?
    let lastLocation: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case pet, user, description, lastLocation, createdAt, updatedAt
    }
}

struct PetLost: Codable {
    let id: String
    let name: String
    let species: String?
    let color: String?
    let age: Int?
    let weight: Int?
    let height: Height?
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, species, color, age, weight, height, avatar
    }
}

struct Height: Codable {
    let feet: Int?
    let inches: Int?
}

struct User: Codable {
    let id: String
    let fullName: String?
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case fullName, avatar
    }
}

struct Explore: Codable {
    let id: String
    let title: String
    let icon: String
}

struct About: Codable {
    let title: String
    let description: CodableValue
}

/// Handle description (can be Int or String)
enum CodableValue: Codable {
    case string(String)
    case int(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
            return
        }
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
            return
        }
        self = .string("")
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value): try container.encode(value)
        case .int(let value): try container.encode(value)
        }
    }
}

struct PetContext {
    let pet: Pet
    let explore: [Explore]?
    let about: [About]?
    let recentActivity: [String]? // you can adjust model later
}

extension HomeResponse {
    func allPets() -> [Pet] {
        var pets: [Pet] = []
        
        for section in data {
            switch section.data {
            case .nested(let nestedSections):
                for group in nestedSections {
                    for sub in group {
                        if case .pet(let pet) = sub.data {
                            pets.append(pet)
                        }
                    }
                }
            default:
                break
            }
        }
        return pets
    }
}

extension HomeResponse {
    
    func context(for petId: String) -> PetContext? {
        for section in data {
            if case .nested(let nestedGroups) = section.data {
                for group in nestedGroups {
                    var foundPet: Pet?
                    var explore: [Explore]?
                    var about: [About]?
                    var recentActivity: [String]?
                    
                    for sub in group {
                        switch sub.data {
                        case .pet(let pet):
                            if pet.id == petId {
                                foundPet = pet
                            }
                        case .explore(let exploreItems):
                            explore = exploreItems
                        case .about(let aboutItems):
                            about = aboutItems
                        case .empty:
                            break
                        default:
                            break
                        }
                    }
                    
                    if let pet = foundPet {
                        return PetContext(
                            pet: pet,
                            explore: explore,
                            about: about,
                            recentActivity: recentActivity
                        )
                    }
                }
            }
        }
        return nil
    }
}

extension HomeResponse {
    /// Total number of top-level sections (homeSection, lostSection, etc.)
    func numberOfSections() -> Int {
        return data.count
    }    
}

