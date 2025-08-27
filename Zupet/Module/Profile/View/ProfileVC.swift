//
//  ProfileVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 24/08/25.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeBold(18)
        }
    }
    @IBOutlet weak var lblEmail: UILabel!{
        didSet{
            lblEmail.font = .manropeRegular(14)
        }
    }
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            lblName.font = .manropeBold(24)
        }
    }
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Apply diagonal gradient to btnContinue button and background view
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }

    @IBAction func settingOnPress(_ sender: UIButton) {
        push(SettingVC.self, from: .profile)
    }
    
}
