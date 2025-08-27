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
    @IBOutlet weak var txtPassword: PasswordTextField!
    @IBOutlet weak var otpView: OTPView!
    
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTimeCount: UILabel!
    @IBOutlet weak var lblResendOtp: UILabel!
    
    var parameters: [String: Any]? = nil
    var isOtpComplete : Bool? = false
    var otp : String? = nil
    var email : String? = nil
    
    // ✅ Additions for timer
    private var timer: Timer?
    private var remainingSeconds: Int = 30
    
    deinit {
        timer?.invalidate() // ✅ Cleanup timer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otpView.delegate = self
        self.lblSubTitle.text = "Please enter the 6-digit code sent to your email \(email ?? "") for verification."
        setupHighlightsAsync()
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate() // ✅ Cleanup timer
    }
    
    private func startTimer() {
        remainingSeconds = 30
        lblTimeCount.isHidden = false
        lblResendOtp.isUserInteractionEnabled = false
        lblResendOtp.alpha = 0.5
        updateTimerLabel()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingSeconds -= 1
            self.updateTimerLabel()
            
            if self.remainingSeconds <= 0 {
                self.timer?.invalidate()
                self.lblTimeCount.isHidden = true
                self.lblResendOtp.isUserInteractionEnabled = true
                self.lblResendOtp.alpha = 1.0
            }
        }
    }
    
    // ✅ New: Timer label update
    private func updateTimerLabel() {
        lblTimeCount.text = "Request new code in 00:\(String(format: "%02d", remainingSeconds))"
    }
    
    private func setupHighlightsAsync() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let resend = "Resend Again"
            
            DispatchQueue.main.async {
                self.lblSubTitle.addTappableHighlight(substring: self.email ?? "", color: .ThemeOrangeEnd, font: .manropeMedium(16)) {
                    Log.debug("Email tapped!")
                }
                
                self.lblResendOtp.addTappableHighlight(substring: resend, color: .ThemeOrangeEnd, font: .manropeMedium(16)) {
                    if self.remainingSeconds <= 0 {
                        Log.debug("Resend tapped!")
                        self.startTimer()
                        // 🔁 You can call resend OTP API here if needed
                        let param = [ConstantApiParam.Email:self.email ?? ""]
                        APIService.shared.forgotPassword(parameters: param, viewController: self,isResend: true)

                    }
                }
            }
        }
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
