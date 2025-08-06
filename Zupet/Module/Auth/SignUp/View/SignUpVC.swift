//
//  SignUpVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 22/07/25.
//

import UIKit

class SignUpVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    
    private var viewModel: SignUpViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SignUpViewModel(view: self)
    }
    
    // MARK: - Button Action
    @IBAction func termsOnPress(_ sender: UIButton) {
    }
    
    @IBAction func signinOnPress(_ sender: UIButton) {
        popView()
    }
    
    @IBAction func signupOnPress(_ sender: UIButton) {
        Task{
            if await isValid(){
                viewModel.callSignupApi()
            }
        }
    }
    
    private func isValid() async -> Bool {
        if self.txtFullName.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.fullName.rawValue)
            return false
        }else if self.txtEmail.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.emailRequired.rawValue)
            return false
        }else if !Validator.isValidEmail(self.txtEmail.text ?? "") {
            await ToastManager.shared.showToast(message: ErrorMessages.invalidEmail.rawValue)
            return false
        }else if self.txtPhone.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.phone.rawValue)
            return false
        }else if !Validator.isValidPhone(self.txtPhone.text ?? "") {
            await ToastManager.shared.showToast(message: ErrorMessages.invalidPhone.rawValue)
            return false
        }else if self.txtPassword.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.passwordRequired.rawValue)
            return false
        }else if !Validator.isValidPassword(self.txtPassword.text ?? "") {
            await ToastManager.shared.showToast(message: ErrorMessages.invalidPassword.rawValue)
            return false
        }else{
            return true
        }
    }
}

