//
//  HomeViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 19/08/25.
//

import Foundation

final class HomeViewModel {
    /// Weak reference to the view (only if you're using UIKit)
    private weak var view: HomeVC?

    /// Initializer - Injects the view (optional, only if you are using UIKit pattern)
    init(view: HomeVC? = nil) {
        self.view = view
    }
    
    func callLogoutApi() {
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }

            // Get the signup URL from constants
            guard let url = APIConstants.logout else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }

            do {

                // Perform the network request and decode response into SignupModel
                let response: SignupModel = try await APIManagerHelper.shared.handleRequest(
                    .getRequest(url: url, headers: [:]),
                    responseType: SignupModel.self
                )

                // Handle successful response
                if response.success == true {
                    await UserDefaultsManager.shared.clearAll()
                    await self.view?.set(SignInVC.self, from: .main)
                }

                // Show message to user (non-blocking on main thread)
                await ToastManager.shared.showToast(message: response.message ?? "Logout completed.")

            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
}
