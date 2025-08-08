//
//  ForgotPasswordVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 08/08/25.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var bgView: UIView!{
        didSet {
            bgView.layer.cornerRadius = 20
            bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bgView.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func continueOnPress(_ sender: UIButton) {
        Task{
            if await isValid(){
                let param = [ConstantApiParam.Email:self.txtEmail.text ?? ""]
                APIService.shared.forgotPassword(parameters: param, viewController: self)
            }
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        popView()
    }
    
    private func isValid() async -> Bool {
        
        if txtEmail.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.emailRequired.rawValue)
            return false
        }
        
        if !Validator.isValidEmail(txtEmail.text ?? "") {
            await ToastManager.shared.showToast(message: ErrorMessages.invalidEmail.rawValue)
            return false
        }
        
        return true
    }
    
}
