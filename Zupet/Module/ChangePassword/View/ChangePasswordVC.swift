//
//  ChangePasswordVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 26/08/25.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var txtConfirmPassword: PasswordTextField!
    @IBOutlet weak var txtNewPassword: PasswordTextField!
    @IBOutlet weak var txtCurrentPassword: PasswordTextField!
    @IBOutlet weak var lbltitle: UILabel!{
        didSet{
            lbltitle.font = .manropeBold(18)
            lbltitle.localize("Change Password")
        }
    }
    
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var bgView: UIView!

    private var viewModel : ChangePasswordViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ChangePasswordViewModel(view: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Apply diagonal gradient to btnContinue button and background view
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        popView()
    }
    
    @IBAction func changeOnPress(_ sender: UIButton) {
        Task{ [weak self] in
            if await self?.isValid() == true{
                self?.viewModel?.changePasswordOnPress()
            }
        }
    }
    
    private func isValid() async -> Bool {
        
        if txtCurrentPassword.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.CurrentPassword.rawValue)
            return false
        }
        
        if !Validator.isValidPassword(txtCurrentPassword.text ?? "") {
            await ToastManager.shared.showToast(message: ErrorMessages.validOldPassword.rawValue)
            return false
        }
        
        if txtNewPassword.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.NewPassword.rawValue)
            return false
        }
        
        if !Validator.isValidPassword(txtNewPassword.text ?? "") {
            await ToastManager.shared.showToast(message: ErrorMessages.validNewPassword.rawValue)
            return false
        }
        
        if txtConfirmPassword.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.ConfirmPassword.rawValue)
            return false
        }
        
        if !Validator.isValidPassword(txtConfirmPassword.text ?? "") {
            await ToastManager.shared.showToast(message: ErrorMessages.confirmPasswordRequired.rawValue)
            return false
        }
        
        if txtConfirmPassword.trim() != txtNewPassword.trim() {
            await ToastManager.shared.showToast(message: ErrorMessages.ConfirmNewPassword.rawValue)
            return false
        }
        
        return true
    }
}
