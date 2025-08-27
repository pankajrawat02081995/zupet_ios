//
//  EditProfileViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 26/08/25.
//

import Foundation

final class EditProfileViewModel{
    
    private var view : EditProfileVC
    init (view:EditProfileVC) {
        self.view = view
    }
    
    func callEditProfileAPI(){
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }

            // Get the signup URL from constants
            guard let url = APIConstants.updateProfile else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }

            // Construct request parameters
            let parameters: [String: Any] = await [
                ConstantApiParam.FullName: self.view.txtName.text ?? "",
                ConstantApiParam.CountryCode: self.view.txtPhone.prefixText?.replacingOccurrences(of: "(", with: "")
                    .replacingOccurrences(of: ")", with: "") ?? "",
                ConstantApiParam.Phone: self.view.txtPhone.text ?? ""
            ]
            Log.debug(parameters)

            do {
                // Convert parameters to JSON Data
                let jsonData = try await APIManagerHelper.shared.convertIntoData(from: parameters)

                // Perform the network request and decode response into SignupModel
                let response: SigninModel = try await APIManagerHelper.shared.handleRequest(
                    .postRequest(url: url, body: jsonData, method: .post, headers: [:]),
                    responseType: SigninModel.self
                )

                // Handle successful response
                if response.success == true {
                    await UserDefaultsManager.shared.set(response.data, forKey: UserDefaultsKey.LoginResponse)
                    await self.view.popView()
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
