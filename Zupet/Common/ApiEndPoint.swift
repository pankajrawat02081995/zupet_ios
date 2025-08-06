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
    
    static let baseURL = "http://172.105.13.154:9003/api/"
    
    static let version = "v1/mobile-app/users/"
    
    static var login: URL? { url("auth/login") }
    static var signup: URL? { url("auth/signup") }
    
    
    
    
    private static func url(_ path: String) -> URL? {
        URL(string: baseURL + version + path)
    }
    
}
