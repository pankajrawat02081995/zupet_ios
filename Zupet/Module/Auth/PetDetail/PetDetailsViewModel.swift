//
//  PetDetailsViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 07/08/25.
//

final class PetDetailsViewModel{
    
    /// Weak reference to the view (only if you're using UIKit)
    private weak var view: PetDetailVC?
    
    /// Initializer - Injects the view (optional, only if you are using UIKit pattern)
    init(view: PetDetailVC? = nil) {
        self.view = view
    }
    
    func createPet(){
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }
            
            // Get the signup URL from constants
            guard let url = APIConstants.petCreate else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }
            
           
            // Construct request parameters
            let parameters: [String: Any] = await [
                ConstantApiParam.name: self.view?.txtPetName.text ?? "",
                ConstantApiParam.species: self.view?.txtSpecies.text ?? "",
                ConstantApiParam.noseId: "1234",
                ConstantApiParam.breed : self.view?.txtBreed.text ?? "",
                ConstantApiParam.age: Int(self.view?.txtAge.text ?? "") ?? 0,
                ConstantApiParam.weight: Int(self.view?.txtWeight.text ?? "") ?? 0,
                ConstantApiParam.height: [ConstantApiParam.feet:Int(self.view?.txtHeight.text ?? "") ?? 0,
                                          ConstantApiParam.inches:Int(self.view?.txtHeightInch.text ?? "") ?? 0]
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
                    // You can call delegate or closure to notify view
                    await self.view?.push(WelcomeVC.self, from: .main)
                }
                
                // Show message to user (non-blocking on main thread)
                await ToastManager.shared.showToast(message: response.message ?? "Pet Create completed.")
                
            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
}
