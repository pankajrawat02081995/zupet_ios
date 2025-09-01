//
//  ProfileViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 30/08/25.
//

import Foundation

final class ProfileViewModel{
    
    private var view : ProfileVC?
    var profileModel : ProfileModel?
    var petModel : OwnPetModel?
    
    init(view:ProfileVC) {
        self.view = view
    }
    
    func getProfileData(){
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }
            
            // Get the signup URL from constants
            guard let url = APIConstants.getProfile else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }
            
            do {
                
                // Perform the network request and decode response into SignupModel
                let response: ProfileModel = try await APIManagerHelper.shared.handleRequest(
                    .getRequest(url: url, headers: [:]),isloaderHide:profileModel == nil,
                    responseType: ProfileModel.self
                )
                // Handle successful response
                if response.success == false {
                    await ToastManager.shared.showToast(message: response.message )
                }else{
                    profileModel = response
                    await view?.setupData()
                    getPetData()
                    await self.view?.tableView.reloadData()
                }
                
            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
    
    func getPetData(){
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }
            
            // Get the signup URL from constants
            guard let url = APIConstants.getPet else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }
            
            do {
                
                // Perform the network request and decode response into SignupModel
                let response: OwnPetModel = try await APIManagerHelper.shared.handleRequest(
                    .getRequest(url: url, headers: [:]),isloaderHide:petModel == nil,
                    responseType: OwnPetModel.self
                )
                // Handle successful response
                if response.success == false {
                    await ToastManager.shared.showToast(message: response.message )
                }else{
                    petModel = response
                    await self.view?.collectionView.reloadData()
                }
                
            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
}
