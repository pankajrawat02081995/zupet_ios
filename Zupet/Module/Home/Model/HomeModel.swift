//
//  HomeModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 19/08/25.
//

import Foundation

// MARK: - Root
struct HomeResponse: Codable {
    let success: Bool
    let message: String
    let data: [HomeSection]
}

// MARK: - Section
struct HomeSection: Codable {
    let section: String
    let heading: Heading
    let data: HomeSectionData
}

// MARK: - Heading
struct Heading: Codable {
    let title: String
    let icon: String
}

// MARK: - SectionData (custom wrapper to handle different formats)
enum HomeSectionData: Codable {
    case petGroups([[PetSubSection]])
    case lostPets([LostPet])
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Try lost pets (array of LostPet)
        if let lost = try? container.decode([LostPet].self) {
            self = .lostPets(lost)
            return
        }
        
        // Try [[PetSubSection]]
        if let groups = try? container.decode([[PetSubSection]].self) {
            self = .petGroups(groups)
            return
        }
        
        self = .unknown
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .petGroups(let groups):
            try container.encode(groups)
        case .lostPets(let lost):
            try container.encode(lost)
        case .unknown:
            try container.encodeNil()
        }
    }
}

// MARK: - Pet Sub Sections (pet card, explore, activity, about)
struct PetSubSection: Codable {
    let section: String
    let heading: Heading
    let data: PetSubData
}

// Handle different section types (pet, explore, about, activity)
enum PetSubData: Codable {
    case pet(Pet)
    case explore([ExploreItem])
    case about([AboutItem])
    case activity([RecentActivity])
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let pet = try? container.decode(Pet.self) {
            self = .pet(pet)
            return
        }
        if let explore = try? container.decode([ExploreItem].self) {
            self = .explore(explore)
            return
        }
        if let about = try? container.decode([AboutItem].self) {
            self = .about(about)
            return
        }
        if let activity = try? container.decode([RecentActivity].self) {
            self = .activity(activity)
            return
        }
        self = .unknown
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .pet(let pet): try container.encode(pet)
        case .explore(let explore): try container.encode(explore)
        case .about(let about): try container.encode(about)
        case .activity(let activity): try container.encode(activity)
        case .unknown: try container.encodeNil()
        }
    }
}

// MARK: - Models
struct Pet: Codable {
    let id: String
    let name: String
    let avatar: String
    let species: String
    let breed: String
    let color: String
    let dob: String
    let mood: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id", name, avatar, species, breed, color, dob, mood
    }
}

struct ExploreItem: Codable {
    let id: String
    let title: String
    let icon: String
}

struct AboutItem: Codable {
    let title: String
    let description: AboutDescription
}

extension AboutDescription {
    var valueAsString: String {
        switch self {
        case .int(let v): return "\(v)"
        case .string(let v): return v
        }
    }
}


// description is sometimes Int, sometimes String
enum AboutDescription: Codable {
    case int(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intVal = try? container.decode(Int.self) {
            self = .int(intVal)
        } else if let strVal = try? container.decode(String.self) {
            self = .string(strVal)
        } else {
            self = .string("")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let val):
            try container.encode(val)
        case .string(let val):
            try container.encode(val)
        }
    }
}


struct RecentActivity: Codable {} // (empty for now, API gave [])

struct LostPet: Codable {
    let id: String
    let pet: PetInfo
    let user: LostUser
    let description: String
    let lastLocation: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id", pet, user, description, lastLocation, createdAt, updatedAt
    }
}

struct PetInfo: Codable {
    let id: String
    let name: String
    let species: String
    let color: String
    let dob: String
    let weight: Int
    let height: PetHeight
    let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id", name, species, color, dob, weight, height, avatar
    }
}

struct PetHeight: Codable {
    let feet: Int
    let inches: Int
}

struct LostUser: Codable {
    let id: String
    let fullName: String
    let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id", fullName, avatar
    }
}

extension HomeResponse {
    
    /// ✅ Get all pets array
    func getAllPets() -> [Pet] {
        var pets: [Pet] = []
        for section in data {
            if case .petGroups(let groups) = section.data {
                for group in groups {
                    for sub in group {
                        if case .pet(let pet) = sub.data {
                            pets.append(pet)
                        }
                    }
                }
            }
        }
        return pets
    }
    
    /// ✅ Get pet details by ID
    func getPetDetails(by id: String) -> Pet? {
        for section in data {
            if case .petGroups(let groups) = section.data {
                for group in groups {
                    for sub in group {
                        if case .pet(let pet) = sub.data, pet.id == id {
                            return pet
                        }
                    }
                }
            }
        }
        return nil
    }
    
    /// ✅ Get all available sections
    func getAllSections() -> [String] {
        return data.map { $0.section }
    }
    
    /// ✅ Get all available sections (including nested ones)
    /// ✅ Get all sections for a specific pet ID
        func getSections(for petID: String) -> [String] {
            var result: [String] = []
            
            for section in data {
                if case .petGroups(let groups) = section.data {
                    for group in groups {
                        var belongsToPet = false
                        
                        // first find if this group has the pet
                        for sub in group {
                            if case .pet(let pet) = sub.data, pet.id == petID {
                                belongsToPet = true
                                break
                            }
                        }
                        
                        // if yes → collect all sections inside this group
                        if belongsToPet {
                            result.append(contentsOf: group.map { $0.section })
                        }
                    }
                }
            }
            
            return result
        }
    
    /// ✅ Get explore items for a specific pet ID
    func getExplore(for petID: String) -> [ExploreItem] {
        for section in data {
            if case .petGroups(let groups) = section.data {
                for group in groups {
                    var hasPet = false
                    for sub in group {
                        if case .pet(let pet) = sub.data, pet.id == petID {
                            hasPet = true
                        }
                    }
                    if hasPet {
                        for sub in group {
                            if case .explore(let items) = sub.data {
                                return items
                            }
                        }
                    }
                }
            }
        }
        return []
    }
    
    /// ✅ Get recent activity for pet ID
    func getRecentActivity(for petID: String) -> [RecentActivity] {
        for section in data {
            if case .petGroups(let groups) = section.data {
                for group in groups {
                    var hasPet = false
                    for sub in group {
                        if case .pet(let pet) = sub.data, pet.id == petID {
                            hasPet = true
                        }
                    }
                    if hasPet {
                        for sub in group {
                            if case .activity(let items) = sub.data {
                                return items
                            }
                        }
                    }
                }
            }
        }
        return []
    }
    
    /// ✅ Get about info for pet ID
    func getAbout(for petID: String) -> [AboutItem] {
        for section in data {
            if case .petGroups(let groups) = section.data {
                for group in groups {
                    var hasPet = false
                    for sub in group {
                        if case .pet(let pet) = sub.data, pet.id == petID {
                            hasPet = true
                        }
                    }
                    if hasPet {
                        for sub in group {
                            if case .about(let items) = sub.data {
                                return items
                            }
                        }
                    }
                }
            }
        }
        return []
    }
    
    /// ✅ Get lost pets
    func getLostPets() -> [LostPet] {
        for section in data {
            if case .lostPets(let lost) = section.data {
                return lost
            }
        }
        return []
    }
}

