//
//  DeleteAccountOTPVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 03/09/25.
//

import UIKit

class DeleteAccountOTPVC: UIViewController {
    
    @IBOutlet weak var lblSubtitle: UILabel!{
        didSet{
            lblSubtitle.font = .manropeBold(16)
        }
    }
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeBold(18)
        }
    }
    
    @IBOutlet weak var lblTimeCount: UILabel!
    @IBOutlet weak var lblResendOtp: UILabel!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var otpView: OTPView!

    var email : String?
    var parameters: [String: Any]? = nil
    var isOtpComplete : Bool? = false
    var otp : String? = nil

    // ✅ Additions for timer
    private var timer: Timer?
    private var remainingSeconds: Int = 30

    deinit {
        timer?.invalidate() // ✅ Cleanup timer
        Log.debug("OtpVC deallocated – ✅ no memory hold")
    }
    
    
    private var viewModel : DeleteAccountOTPVIewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpView.delegate = self
        viewModel = DeleteAccountOTPVIewModel(view: self)
        updateContinueButtonState()
        setupHighlightsAsync()
        startTimer()
    }
    
    private func updateContinueButtonState() {
        btnVerify.isEnabled = isOtpComplete ?? false
        btnVerify.alpha = isOtpComplete ?? false ? 1.0 : 0.5
    }
    
    private func setupHighlightsAsync() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let resend = "Resend Again"
            
            DispatchQueue.main.async {

                self.lblResendOtp.addTappableHighlight(substring: resend, color: .ThemeOrangeEnd, font: .manropeMedium(16)) {
                    if self.remainingSeconds <= 0 {
                        Log.debug("Resend tapped!")
                        self.startTimer()
                        // 🔁 You can call resend OTP API here if needed
//                        self.viewModel?.callOtpVerify(isResend: true)
                    }
                }
            }
        }
    }
    
    // ✅ New: Start 30 sec reverse timer
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
    
    @IBAction func verifyOnPress(_ sender: UIButton) {
        Task {
            if isOtpComplete ?? false {
                viewModel?.callDeleteAccountApi()
            }
        }
    }
    @IBAction func backOnPress(_ sender: UIButton) {
        popView()
    }
    

}

extension DeleteAccountOTPVC: OTPViewDelegate {
    func otpDidChange(code: String) {
        // Optional real-time logic
        Log.debug("This is code\(code)")
        otp = code
    }
    
    func otpDidComplete(isComplete: Bool) {
        // Auto-verify maybe
        Log.debug("is This complete code \(isComplete)")
        isOtpComplete = isComplete
        updateContinueButtonState()
    }
}
