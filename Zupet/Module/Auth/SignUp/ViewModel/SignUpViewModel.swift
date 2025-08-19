//
//  SignUpViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 06/08/25.
//

import Foundation

/// ViewModel for handling the sign-up logic safely and cleanly
final class SignUpViewModel {

    /// Weak reference to the view (only if you're using UIKit)
    private weak var view: SignUpVC?

    /// Initializer - Injects the view (optional, only if you are using UIKit pattern)
    init(view: SignUpVC? = nil) {
        self.view = view
    }

    /// Function to trigger sign-up API call asynchronously
    func callSignupApi() {
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }

            // Get the signup URL from constants
            guard let url = APIConstants.signup else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }

            // Construct request parameters
            let parameters: [String: Any] = await [
                ConstantApiParam.Email: self.view?.txtEmail.text ?? "",
                ConstantApiParam.Password: self.view?.txtPassword.text ?? "",
                ConstantApiParam.FullName: self.view?.txtFullName.text ?? "",
                ConstantApiParam.Phone: self.view?.txtPhone.text ?? ""
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
                        vc.parameters = parameters
                    }
                }

                // Show message to user (non-blocking on main thread)
                await ToastManager.shared.showToast(message: response.message ?? "Signup completed.")

            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
}
