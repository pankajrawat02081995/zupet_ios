//
//  LetsStartVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 01/08/25.
//

import UIKit

class LetsStartVC: UIViewController {

    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var btnStart: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Apply diagonal gradient to btnContinue button and background view
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
        
        btnStart.applyDiagonalGradient()
        btnStart.updateGradientFrameIfNeeded()
    }

    @IBAction func startOnPress(_ sender: UIButton) {
        Task{ [weak self] in
            self?.push(PetSelectionVC.self, from: .main)
            APIService.shared.fatchBreed()
        }
    }
    
}
