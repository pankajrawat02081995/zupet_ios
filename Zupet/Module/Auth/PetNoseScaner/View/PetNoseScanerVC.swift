//
//  PetNoseScanerVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 01/08/25.
//

import UIKit

class PetNoseScanerVC: UIViewController {

    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var btnFlip: UIButton!
    var petSpecies : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Apply diagonal gradient to btnContinue button and background view
        btnContinue.applyDiagonalGradient()
        btnContinue.updateGradientFrameIfNeeded()

        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    @IBAction func continewOnPress(_ sender: UIButton) {
        push(PetDetailVC.self, from: .main) { [weak self] vc in
            vc.petSpecies = self?.petSpecies
        }
    }
    
    @IBAction func flashOnPress(_ sender: UIButton) {
    }
    @IBAction func refreshOnPress(_ sender: UIButton) {
    }
    
    @IBAction func flipOnPress(_ sender: UIButton) {
    }
    
}
