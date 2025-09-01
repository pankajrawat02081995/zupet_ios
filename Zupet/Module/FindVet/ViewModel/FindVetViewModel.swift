//
//  FindVetViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 01/09/25.
//

import Foundation

final class FindVetViewModel {
    
    private var view : FindVetVC?
    
    var vetModel : FindVetModel?
    
    init(view:FindVetVC) {
        self.view = view
    }
    
    func getVets(radius:Int,location:UserLocation){
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard self != nil else { return }
            
            // Get the signup URL from constants
            guard let url = APIConstants.getVetList else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }
            
            do {
//                ConstantApiParam.Search:"",
                let param : [String:Any] = [ConstantApiParam.Country:location.country ?? "",ConstantApiParam.City:location.city ?? "",ConstantApiParam.Lat:location.latitude ?? 0.0,ConstantApiParam.Lng:location.longitude ?? 0.0,ConstantApiParam.Radius:radius]
                let jsonData = try await APIManagerHelper.shared.convertIntoData(from: param)

                // Perform the network request and decode response into SignupModel
                let response: FindVetModel = try await APIManagerHelper.shared.handleRequest(
                    .postRequest(url: url, body: jsonData, method: .post, headers: [:]),
                    responseType: FindVetModel.self
                )
                // Handle successful response
                if response.success == false {
                    await ToastManager.shared.showToast(message: response.message )
                }else{
                    self?.vetModel = response
                    await self?.view?.setupView()
                    await self?.view?.collectionView.reloadData()
                }
                
            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
}
