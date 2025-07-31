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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Offload attributed string setup to background, then apply on main
        setupHighlightsAsync()

        // Set OTPView delegate (safe on main)
        otpView.delegate = self
    }

    private func setupHighlightsAsync() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            let email = "contact.ZupetAI@gmail.com"
            let resend = "Resend Again"

            DispatchQueue.main.async {
                self.lblSubTitle.addTappableHighlight(substring: email, color: .ThemeOrangeEnd, font: .monroeMedium(16)) {
                    Log.debug("Email tapped!")
                }

                self.lblResendOtp.addTappableHighlight(substring: resend, color: .ThemeOrangeEnd, font: .monroeMedium(16)) {
                    Log.debug("Resend tapped!")
                }
            }
        }
    }

    @IBAction func verifyOnPress(_ sender: UIButton) {
        push(LetsStartVC.self, from: .main)
    }

    deinit {
        print("OtpVC deallocated – ✅ no memory hold")
    }
}

extension OtpVC: OTPViewDelegate {
    func otpDidChange(code: String) {
        // Optional real-time logic
    }

    func otpDidComplete(code: String) {
        // Auto-verify maybe
    }
}
