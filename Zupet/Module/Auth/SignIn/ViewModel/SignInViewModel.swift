//
//  SignInViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 07/08/25.
//

import Foundation

final class SignInViewModel {
    
    /// Weak reference to the view (only if you're using UIKit)
    private weak var view: SignInVC?

    /// Initializer - Injects the view (optional, only if you are using UIKit pattern)
    init(view: SignInVC? = nil) {
        self.view = view
    }

    /// Function to trigger sign-up API call asynchronously
    func callSignInApi() {
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }

            // Get the signup URL from constants
            guard let url = APIConstants.login else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }

            // Construct request parameters
            let parameters: [String: Any] = await [
                ConstantApiParam.Email: self.view?.txtEmail.text ?? "",
                ConstantApiParam.Password: self.view?.txtPassword.text ?? "",
            ]

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
                    await self.view?.push(OtpVC.self, from: .main){ [weak self] vc in
                        vc.email = self?.view?.txtEmail.text ?? ""
                    }
                }

                // Show message to user (non-blocking on main thread)
                await ToastManager.shared.showToast(message: response.message ?? "Sign In completed.")

            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
    
    func socialLogin() {
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }

            // Get the signup URL from constants
            guard let url = APIConstants.socialLogin else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }

            // Construct request parameters
            let parameters: [String: Any] = await [
                ConstantApiParam.Email: self.view?.txtEmail.text ?? "",
                ConstantApiParam.Password: self.view?.txtPassword.text ?? "",
            ]

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
                    await self.view?.push(TabbarVC.self, from: .tabbar)
                }

                // Show message to user (non-blocking on main thread)
                await ToastManager.shared.showToast(message: response.message ?? "Sign In completed.")

            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
}
