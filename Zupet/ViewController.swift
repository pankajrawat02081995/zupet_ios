    //
    //  ViewController.swift
    //  Zupet
    //
    //  Created by Pankaj Rawat on 21/07/25.
    //

    import UIKit

    class ViewController: UIViewController {
        
        @IBOutlet weak var bgView: UIView!
        override func viewDidLoad() {
            super.viewDidLoad()
            
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            self.bgView.applyDiagonalGradient()
            self.bgView.updateGradientFrameIfNeeded()
        }
        
        
    }
