//
//  LostPetAlertVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 19/08/25.
//

import UIKit

class LostPetAlertVC: UIViewController {

    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeBold(18)
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
    
    @IBAction func backOnPress(_ sender: UIButton) {
        popView()
    }
    
    @IBAction func shareOnPress(_ sender: UIButton) {
    }
}
