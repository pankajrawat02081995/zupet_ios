//
//  PetNoseScanerViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 01/09/25.
//

import Foundation

final class PetNoseScanerViewModel{
    
    private var view : PetNoseScanerVC?
    
    init(view:PetNoseScanerVC) {
        self.view = view
    }
    
    func scanNose(img:String){
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }
            
            // Get the signup URL from constants
            guard let url = APIConstants.noseScaner else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }
            
            // Construct request parameters
            let parameters: [String: Any] =  [
                ConstantApiParam.ImageData: img
            ]
            
            do {
                // Convert parameters to JSON Data
                let jsonData = try await APIManagerHelper.shared.convertIntoData(from: parameters)
                
                // Perform the network request and decode response into SignupModel
                let response: PetNoseScanerModel = try await APIManagerHelper.shared.handleRequest(
                    .postRequest(url: url, body: jsonData, method: .post, headers: [:]),
                    responseType: PetNoseScanerModel.self
                )
                
                // Handle successful response
                if response.success == true {
                    await self.view?.push(PetDetailVC.self, from: .main) { [weak self] vc in
                        guard let self = self else{return}
                        vc.petSpecies = self.view?.petSpecies
                        vc.isBackVisible = self.view?.isBackVisible ?? false
                    }
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
