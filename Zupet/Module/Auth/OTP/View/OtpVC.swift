//
//  OtpVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 22/07/25.
//

import UIKit

class OtpVC: UIViewController {

    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var otpView: OTPView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblSubTitle.addTappableHighlight(substring: "contact.ZupetAI@gmail.com", color: .systemBlue) {
            print("Email tapped!") // Or open mail composer
        }
    }
    

}
