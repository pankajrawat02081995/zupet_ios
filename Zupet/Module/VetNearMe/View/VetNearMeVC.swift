//
//  VetNearMeVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 19/08/25.
//

import UIKit

class VetNearMeVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var txtSeach: UITextField!{
        didSet{
            txtSeach.font = .manropeMedium(14)
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        popView()
    }
    
}
