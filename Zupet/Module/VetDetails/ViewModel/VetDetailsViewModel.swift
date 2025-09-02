//
//  VetDetailsViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 02/09/25.
//

import Foundation

final class VetDetailsViewModel{
    
    private var view : VetDetailsVC?
    private var vetID : String?
    var vetDetailsModel : VetDetailsModel?
    
    init(view:VetDetailsVC,vetID:String) {
        self.view = view
        self.vetID = vetID
    }
    
    func getVetDetails(){
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard self != nil else { return }
            
            // Get the signup URL from constants
            guard let url = APIConstants.getVetDetails(vetID ?? "") else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }
            
            do {

                // Perform the network request and decode response into SignupModel
                let response: VetDetailsModel = try await APIManagerHelper.shared.handleRequest(
                    .getRequest(url: url, headers: [:]),
                    responseType: VetDetailsModel.self
                )
                // Handle successful response
                if response.success == false {
                    await ToastManager.shared.showToast(message: response.message )
                }else{
                    self?.vetDetailsModel = response
                    await self?.view?.setupView()
                    await self?.view?.tableView.reloadData()
                }
                
            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
}
