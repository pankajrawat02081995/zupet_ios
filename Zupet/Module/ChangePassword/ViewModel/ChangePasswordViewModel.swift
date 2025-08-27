//
//  ChangePasswordViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 26/08/25.
//

import Foundation

final class ChangePasswordViewModel{
    private var view : ChangePasswordVC?
    
    init (view:ChangePasswordVC) {
        self.view = view
    }
    
    func changePasswordOnPress(){
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }

            // Get the signup URL from constants
            guard let url = APIConstants.changePassword else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }

            // Construct request parameters
            let parameters: [String: Any] = await [
                ConstantApiParam.OldPassword: self.view?.txtCurrentPassword.text ?? "",
                ConstantApiParam.NewPassword: self.view?.txtNewPassword.text ?? ""
            ]
            Log.debug(parameters)

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
                    await self.view?.popView()
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
