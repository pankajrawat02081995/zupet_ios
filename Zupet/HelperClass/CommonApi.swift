//
//  CommonApi.swift
//  Zupet
//
//  Created by Pankaj Rawat on 08/08/25.
//

import UIKit

//MARK: Breed Model

struct BreedResponse: Codable {
    let success: Bool?
    let data: BreedData?
}

struct BreedData: Codable {
    let dogBreeds: [String]?
    let catBreeds: [String]?
    let dogColors: [String]?
    let catColors: [String]?
}


@MainActor
final class APIService {
    
    static let shared = APIService() // Singleton instance
    
    private init() {}
    
    func fatchBreed() {
        Task {
            do {
                guard let url = APIConstants.petBreed else { return }
                let result: BreedResponse = try await SilentAPIManager.shared.fetchDataSilently(
                    url: url,
                    type: BreedResponse.self
                )
                Log.debug(result)
                await UserDefaultsManager.shared.set(result.data, forKey: UserDefaultsKey.BreedData)
                debugPrint(await UserDefaultsManager.shared.get(BreedData.self, forKey: UserDefaultsKey.BreedData)?.catBreeds ?? [])

            } catch {
                Log.debug(error.localizedDescription)
            }
        }
    }
    
    func forgotPassword(parameters: [String:Any],viewController: UIViewController,isReset:Bool=false,isResend:Bool=false)  {
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
                    if isResend == false{
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

final class SilentAPIManager {
    static let shared = SilentAPIManager()
    private init() {}
    
    private var cacheMemory: [String: Data] = [:]
    
    func fetchDataSilently<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        let cacheKey = url.absoluteString
        
        // 1. Return cached value instantly if available
        if let localData = cacheMemory[cacheKey] ?? UserDefaults.standard.data(forKey: cacheKey),
           let decoded = try? JSONDecoder().decode(T.self, from: localData) {
            // Trigger silent refresh in background
            Task {
                try? await self.refreshData(url: url, type: type)
            }
            return decoded
        }
        
        // 2. No cache? Fetch from server
        return try await refreshData(url: url, type: type)
    }
    
    private func refreshData<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(try await "Bearer \(getAuthToken())", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Cache
        cacheMemory[url.absoluteString] = data
        UserDefaults.standard.set(data, forKey: url.absoluteString)
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func getAuthToken() async throws -> String {
        return await UserDefaultsManager.shared
            .get(UserData.self, forKey: UserDefaultsKey.LoginResponse)?
            .token ?? ""
    }
}
