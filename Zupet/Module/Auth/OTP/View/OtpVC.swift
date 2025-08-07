//
//  OtpVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 22/07/25.
//

import UIKit

class OtpVC: UIViewController {
    
    @IBOutlet weak var lblTimeCount: UILabel!
    @IBOutlet weak var lblResendOtp: UILabel!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var otpView: OTPView!
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    
    private var viewModel : OtpViewModel?
    
    var email : String?
    var parameters: [String: Any]? = nil
    var isOtpComplete : Bool? = false
    var otp : String? = nil

    // ✅ Additions for timer
    private var timer: Timer?
    private var remainingSeconds: Int = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OtpViewModel(view: self)
        
        updateContinueButtonState()
        
        self.lblSubTitle.text = "Please enter the 6-digit code sent to your email \(email ?? "") for verification."
        setupHighlightsAsync()
        
        otpView.delegate = self
        
        // ✅ Start 30 sec timer
        startTimer()
    }
    
    private func setupHighlightsAsync() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            let resend = "Resend Again"
            
            DispatchQueue.main.async {
                self.lblSubTitle.addTappableHighlight(substring: self.email ?? "", color: .ThemeOrangeEnd, font: .monroeMedium(16)) {
                    Log.debug("Email tapped!")
                }

                self.lblResendOtp.addTappableHighlight(substring: resend, color: .ThemeOrangeEnd, font: .monroeMedium(16)) {
                    if self.remainingSeconds <= 0 {
                        Log.debug("Resend tapped!")
                        self.startTimer()
                        // 🔁 You can call resend OTP API here if needed
                        self.viewModel?.callOtpVerify()
                    }
                }
            }
        }
    }
    
    @IBAction func verifyOnPress(_ sender: UIButton) {
        Task {
            if isOtpComplete ?? false {
                viewModel?.callOtpVerify()
            }
        }
    }
    
    deinit {
        timer?.invalidate() // ✅ Cleanup timer
        Log.debug("OtpVC deallocated – ✅ no memory hold")
    }
    
    private func updateContinueButtonState() {
        btnVerify.isEnabled = isOtpComplete ?? false
        btnVerify.alpha = isOtpComplete ?? false ? 1.0 : 0.5
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
}


extension OtpVC: OTPViewDelegate {
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
