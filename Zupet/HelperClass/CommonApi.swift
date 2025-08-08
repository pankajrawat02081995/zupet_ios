//
//  CommonApi.swift
//  Zupet
//
//  Created by Pankaj Rawat on 08/08/25.
//

import UIKit

struct UserProfile: Decodable {
    let id: Int
    let name: String
    let email: String
}

@MainActor
final class APIService {
    static let shared = APIService() // Singleton instance
    
    private init() {}
    
    func callSilentAPI<T: Decodable>(url: URL, type: T.Type) async throws -> T? {
        return try await withCheckedThrowingContinuation { continuation in
            SilentAPIManager.shared.fetchDataSilently(url: url, type: type) { model in
                continuation.resume(returning: model)
            }
        }
    }

    func forgotPassword(parameters: [String:Any],viewController: UIViewController,isReset:Bool=false)  {
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Get the signup URL from constants
            guard let url = APIConstants.forgotPassword else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }

            do {
                // Convert parameters to JSON Data
                let jsonData = try await APIManagerHelper.shared.convertIntoData(from: parameters)

                // Perform the network request and decode response into SignupModel
                let response: SignupModel = try await APIManagerHelper.shared.handleRequest(
                    .postRequest(url: url, body: jsonData, method: .post, headers: [:]),
                    responseType: SignupModel.self
                )

                // Handle successful response
                if response.success == true {
                    // You can call delegate or closure to notify view
                    if isReset{
                        Log.debug("Set Root")
                        viewController.navigationController?.popToRootViewController(animated: true)
                    }else{
                        viewController.push(ResetPassword.self, from: .main){ [weak self] vc in
                            guard self != nil else { return }
                            vc.email = parameters["email"] as? String ?? ""
                        }
                    }
                }

                // Show message to user (non-blocking on main thread)
                await ToastManager.shared.showToast(message: response.message ?? "Forgot Password completed.")

            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
}

import Foundation

final class SilentAPIManager {
    static let shared = SilentAPIManager()
    private init() {}
    
    private var cacheMemory: [String: Data] = [:]
    
    func fetchDataSilently<T: Decodable>(
        url: URL,
        type: T.Type,
        completion: ((T?) -> Void)? = nil
    ) async {
        let cacheKey = url.absoluteString
        
        // Return cached value immediately if available
        if let localData = cacheMemory[cacheKey] ?? UserDefaults.standard.data(forKey: cacheKey) {
            if let decoded = try? JSONDecoder().decode(T.self, from: localData) {
                completion?(decoded)
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        await request.setValue(getAuthToken(), forHTTPHeaderField: "Authorization")
        
        // Background session
        let config = URLSessionConfiguration.background(withIdentifier: UUID().uuidString)
        config.isDiscretionary = false
        config.sessionSendsLaunchEvents = true
        
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { [weak self] data, _, _ in
            guard let self = self, let data = data else {
                DispatchQueue.main.async { completion?(nil) }
                return
            }
            
            // Save to memory + disk
            self.cacheMemory[cacheKey] = data
            UserDefaults.standard.set(data, forKey: cacheKey)
            
            // Decode and return
            if let decoded = try? JSONDecoder().decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completion?(decoded)
                }
            } else {
                DispatchQueue.main.async {
                    completion?(nil)
                }
            }
        }
        
        task.resume()
    }
    
    private func getAuthToken() async -> String {
        // Retrieve from Keychain or other secure store
        return await UserDefaultsManager.shared.get(UserData.self, forKey: UserDefaultsKey.LoginResponse)?.token ?? ""
    }
}
