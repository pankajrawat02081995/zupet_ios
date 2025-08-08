//
//  ResetPassword.swift
//  Zupet
//
//  Created by Pankaj Rawat on 08/08/25.
//

import UIKit
class ResetPassword:UIViewController{
    
    @IBOutlet weak var bgView: UIView!{
        didSet {
            bgView.layer.cornerRadius = 20
            bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bgView.clipsToBounds = true
        }
    }
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var otpView: OTPView!
    
    var parameters: [String: Any]? = nil
    var isOtpComplete : Bool? = false
    var otp : String? = nil
    var email : String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otpView.delegate = self
    }
    
    @IBAction func continueOnPress(_ sender: UIButton) {
        Task{
            if await isValid(){
                let param = [ConstantApiParam.Email:email ?? "",
                             ConstantApiParam.Password:txtPassword.text ?? "",
                             ConstantApiParam.otp:otp ?? ""]
                APIService.shared.forgotPassword(parameters: param, viewController: self,isReset: true)
            }
        }
    }
    
    private func isValid() async -> Bool {
        
        if !(isOtpComplete ?? false){
            await ToastManager.shared.showToast(message: ErrorMessages.completeOtp.rawValue)
            return false
        }
        
        if txtPassword.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.passwordRequired.rawValue)
            return false
        }
        
        if !Validator.isValidPassword(txtPassword.text ?? "") {
            await ToastManager.shared.showToast(message: ErrorMessages.invalidPassword.rawValue)
            return false
        }
        
        return true
    }
    
}

extension ResetPassword: OTPViewDelegate {
    func otpDidChange(code: String) {
        // Optional real-time logic
        Log.debug("This is code\(code)")
        otp = code
    }
    
    func otpDidComplete(isComplete: Bool) {
        // Auto-verify maybe
        Log.debug("is This complete code \(isComplete)")
        isOtpComplete = isComplete
    }
}
