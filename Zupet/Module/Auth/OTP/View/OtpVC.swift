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
    
    /// The top container view that has rounded top corners
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblSubTitle.addTappableHighlight(substring: "contact.ZupetAI@gmail.com",color: .ThemeOrangeEnd, font: .monroeMedium(16)) {
            Log.debug("Email tapped!") // Or open mail composer
        }
        
        lblResendOtp.addTappableHighlight(substring: "Resend Again",color: .ThemeOrangeEnd, font: .monroeMedium(16)) {
            Log.debug("Resend tapped!") // Or open mail composer
        }
        
        otpView.delegate = self
    }
    
    @IBAction func verifyOnPress(_ sender: UIButton) {
    }
    
}

extension OtpVC:OTPViewDelegate{
    func otpDidChange(code: String) {
    
    }
    
    func otpDidComplete(code: String) {
        
    }
    
    
}
