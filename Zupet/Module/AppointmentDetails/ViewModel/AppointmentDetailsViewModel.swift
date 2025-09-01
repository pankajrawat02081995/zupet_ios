//
//  AppointmentDetailsViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 31/08/25.
//

import Foundation

final class AppointmentDetailsViewModel{
    
    private var view : AppointmentDetailsVC?
    var appointmentModel : AppointmentDetailsModel?
    
    init(view:AppointmentDetailsVC){
        self.view = view
    }
    
    func getAppointmentsData(Id:String){
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }
            
            // Get the signup URL from constants
            guard let url = APIConstants.getAppointmentDetails(Id) else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }
            
            do {
                // Perform the network request and decode response into SignupModel
                let response: AppointmentDetailsModel = try await APIManagerHelper.shared.handleRequest(
                    .getRequest(url: url, headers: [:]),
                    responseType: AppointmentDetailsModel.self
                )
                // Handle successful response
                if response.success == false {
                    await ToastManager.shared.showToast(message: response.message )
                }else{
                    appointmentModel = response
                    await self.view?.setupData()
                    await self.view?.tableView.reloadData()
                }
                
            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
    
    func submitDecision(Id:String,index:Int,decision:String){
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }
            
            // Get the signup URL from constants
            guard let url = APIConstants.submitDecsion(Id) else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }
            
            do {
                let data = appointmentModel?.data?.timeline?[index]
                var param : [String:Any] = [ConstantApiParam.StageId:data?.id ?? "",ConstantApiParam.Decision:decision]
                if decision == "accepted"{
                    param[ConstantApiParam.AlternateSlot] = await view?.selectedDate
                }
                let jsonData = try await APIManagerHelper.shared.convertIntoData(from: param)

                // Perform the network request and decode response into SignupModel
                let response: SignupModel = try await APIManagerHelper.shared.handleRequest(
                    .postRequest(url: url, body: jsonData, method: .post, headers: [:]),
                    responseType: SignupModel.self
                )
                // Handle successful response
                if response.success == false {
                    await ToastManager.shared.showToast(message: response.message )
                }else{
                    appointmentModel?.data?.timeline?[index].requiresAction = false
                    await self.view?.tableView.reloadData()
                }
                
            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
}
