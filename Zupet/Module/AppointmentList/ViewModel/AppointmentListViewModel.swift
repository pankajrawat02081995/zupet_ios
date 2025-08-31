//
//  AppointmentListViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 30/08/25.
//

import Foundation

final class AppointmentListViewModel{
    
    private var view : AppointmentListVC?
    var appointmentModel : AppointmentModel?
    
    var count : Int? = 1
    
    init(view:AppointmentListVC) {
        self.view = view
    }
    
    func getAppointmentsData(){
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }
            
            // Get the signup URL from constants
            guard let url = APIConstants.getAppointments else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }
            
            do {
                let parameters = [ConstantApiParam.Page:count]
                let jsonData = try await APIManagerHelper.shared.convertIntoData(from: parameters as [String : Any])
                // Perform the network request and decode response into SignupModel
                let response: AppointmentModel = try await APIManagerHelper.shared.handleRequest(
                    .postRequest(url: url, body: jsonData, method: .post, headers: [:]),
                    responseType: AppointmentModel.self
                )
                // Handle successful response
                if response.success == false {
                    await ToastManager.shared.showToast(message: response.message )
                }else{
                    appointmentModel = response
                    await self.view?.tableView.reloadData()
                }
                
            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
    
    
}
