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
            Task{
                await self?.navigateToNextVC()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }

    // MARK: - Deinit (Debug)

    deinit {
        Log.debug("ViewController deinitialized — no memory held ✅")
    }
}


class AppNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation bar everywhere
        self.setNavigationBarHidden(true, animated: false)
        
        // Enable swipe back gesture
        self.interactivePopGestureRecognizer?.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = true
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
}
