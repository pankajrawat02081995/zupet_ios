//
//  ApiEndPoint.swift
//  Broker Portal
//
//  Created by Pankaj on 23/04/25.
//

import Foundation

//MARK: How to use

//static var posts: URL? { url("/posts") }
//static func post(_ id: Int) -> URL? { url("/posts/\(id)") }

enum APIConstants{
    
    static let baseURL = "https://futuristic-policy.dev.falconsystem.com"
    static let baseAccURL = "https://futuristic-accounting.dev.falconsystem.com"
    
    static let version = "/ams-v1"
    static let versionAcc = "/acc-v1"
    
    static var userlogin: URL? { url("/adminop/userlogin") }
    static var refreshToken: URL? { url("/adminop/get-refresh-token") }
    static var recentActivity: URL? { url("/quoteop/get_quotes_for_broker_recent_activity") }
    static var getPolicy: URL? { url("/quoteop/get-all-policy-data-paginated") }
    
    static var brokerList: URL? { urlAcc("/accounting/broker/get") }
    static func brokerUserList(_ id: Int)-> URL? { urlAcc("accounting/user/get?agency_id=\(id)") }
    static func updateUser(_ id: Int)-> URL? { urlAcc("/accounting/user/update/\(id)") }
    static var addUser: URL? { urlAcc("/accounting/user/add") }
    
    private static func url(_ path: String) -> URL? {
        URL(string: baseURL + version + path)
    }
    
    private static func urlAcc(_ path: String) -> URL? {
        URL(string: baseAccURL + versionAcc + path)
    }
}
