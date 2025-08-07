//
//  OtpViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 07/08/25.
//

import Foundation

final class OtpViewModel{
    
    /// Weak reference to the view (only if you're using UIKit)
    private weak var view: OtpVC?
    
    /// Initializer - Injects the view (optional, only if you are using UIKit pattern)
    init(view: OtpVC? = nil) {
        self.view = view
    }
    
    /// Function to trigger sign-up API call asynchronously
    func callOtpVerify(isResend:Bool=false) {
        Task { [weak self] in
            guard let self else { return }
            
            guard let url = APIConstants.signup else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }
            
            // ✅ Mutate main actor-bound property safely
            await MainActor.run {
                self.view?.parameters?[ConstantApiParam.otp] = self.view?.otp ?? ""
            }
            
            do {
                // ✅ Read from main actor-bound property
                let params: [String: Any] = await MainActor.run {
                    self.view?.parameters ?? [:]
                }
                
                Log.debug(params)
                let jsonData = try await APIManagerHelper.shared.convertIntoData(from: params)
                
                let response: SigninModel = try await APIManagerHelper.shared.handleRequest(
                    .postRequest(url: url, body: jsonData, method: .post, headers: [:]),
                    responseType: SigninModel.self
                )
                
                if response.success == true {
                    if isResend{
                        
                    }else{
                        await UserDefaultsManager.shared.set(response, forKey: UserDefaultsKey.LoginResponse)
                        await self.view?.push(LetsStartVC.self, from: .main)
                    }
                }
                
                await ToastManager.shared.showToast(message: response.message ?? "OTP completed.")
                
            } catch {
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
}
