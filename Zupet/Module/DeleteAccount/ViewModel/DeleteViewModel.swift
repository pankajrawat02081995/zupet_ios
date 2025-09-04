//
//  DeleteViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 03/09/25.
//

import Foundation

final class DeleteViewModel{
    
    private var view : DeleteAccountVC?
    
    init(view: DeleteAccountVC? = nil) {
        self.view = view
    }
    
    func callDeleteAccountApi() {
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }
            
            // Get the signup URL from constants
            guard let url = APIConstants.deleteProfile else {
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
//                    await UserDefaultsManager.shared.clearAll()
                    await self.view?.push(DeleteAccountOTPVC.self, from: .profile)
                }
                
                // Show message to user (non-blocking on main thread)
                await ToastManager.shared.showToast(message: response.message ?? "")
                
            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
}
