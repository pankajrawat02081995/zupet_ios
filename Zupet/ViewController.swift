    //
    //  ViewController.swift
    //  Zupet
    //
    //  Created by Pankaj Rawat on 21/07/25.
    //

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Start 2-second delayed navigation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.navigateToNextVC()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }

    // MARK: - Navigation

    private func navigateToNextVC() {
        // Replace "NextViewController" with your actual destination VC class
        push(SignInVC.self, from: .main)
    }

    // MARK: - Deinit (Debug)

    deinit {
        Log.debug("ViewController deinitialized — no memory held ✅")
    }
}

