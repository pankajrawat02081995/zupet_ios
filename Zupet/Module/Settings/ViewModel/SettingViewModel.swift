//
//  SettingViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 25/08/25.
//

import Foundation
import UIKit

final class SettingViewModel{
    
    private var view:SettingVC?
    
    init(view:SettingVC) {
        self.view = view
    }
    
    func makeSettingsData() -> [SettingsModel] {
        return [
            SettingsModel(
                title: "Account".localized,
                items: [
                    SettingsItem(
                        icon: UIImage(named: "ic_lock_setting"),
                        title: "Edit Profile".localized,
                        isNextIcon: true
                    ),
                    SettingsItem(
                        icon: UIImage(named: "ic_key"),
                        title: "Change Password".localized,
                        isNextIcon: true
                    )
                ]
            ),
            SettingsModel(
                title: "Notifications".localized,
                items: [
                    SettingsItem(
                        icon: UIImage(named: "ic_appointment_bell"),
                        title: "Appointment Reminder".localized,
                        isNextIcon: false
                    )
                ]
            ),
            SettingsModel(
                title: "Preferences".localized,
                items: [
                    SettingsItem(
                        icon: UIImage(named: "ic_language"),
                        title: "Language".localized,
                        isNextIcon: true
                    )
                ]
            ),
            SettingsModel(
                title: "Privacy & Security".localized,
                items: [
                    SettingsItem(
                        icon: UIImage(named: "ic_bin"),
                        title: "Delete Account".localized,
                        isNextIcon: true
                    ),
                    SettingsItem(
                        icon: UIImage(named: "ic_logout"),
                        title: "Logout".localized,
                        isNextIcon: true
                    )
                ]
            )
        ]
    }
    
    func callLogoutApi() {
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }
            
            // Get the signup URL from constants
            guard let url = APIConstants.logout else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }
            
            do {
                
                // Perform the network request and decode response into SignupModel
                let response: SignupModel = try await APIManagerHelper.shared.handleRequest(
                    .getRequest(url: url, headers: [:]),
                    responseType: SignupModel.self
                )
                
                // Handle successful response
                if response.success == true {
                    await UserDefaultsManager.shared.clearAll()
                    await self.view?.set(SignInVC.self, from: .main)
                }
                
                // Show message to user (non-blocking on main thread)
                await ToastManager.shared.showToast(message: response.message ?? "Logout completed.")
                
            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
    func callDeleteApi() {
        // Use Swift concurrency with weak self to avoid retain cycles
        Task { [weak self] in
            // Optional binding to ensure `self` still exists
            guard let self else { return }
            
            // Get the signup URL from constants
            guard let url = APIConstants.deleteProfile else {
                await ToastManager.shared.showToast(message: "Invalid URL")
                return
            }
            
            do {
                
                // Perform the network request and decode response into SignupModel
                let response: SignupModel = try await APIManagerHelper.shared.handleRequest(
                    .getRequest(url: url, headers: [:]),
                    responseType: SignupModel.self
                )
                
                // Handle successful response
                if response.success == true {
                    await UserDefaultsManager.shared.clearAll()
                    await self.view?.set(SignInVC.self, from: .main)
                }
                
                // Show message to user (non-blocking on main thread)
                await ToastManager.shared.showToast(message: response.message ?? "Logout completed.")
                
            } catch {
                // Show error message to user
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }

}
