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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
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

    // MARK: - Navigation

    private func navigateToNextVC() async {
        // Replace "NextViewController" with your actual destination VC class
         let token = await UserDefaultsManager.shared.get(UserData.self, forKey: UserDefaultsKey.LoginResponse)
        if token.isNil {
            push(OnboardingVC.self, from: .main)
        }else{
            push(TabbarVC.self, from: .tabbar)
        }
        
    }

    // MARK: - Deinit (Debug)

    deinit {
        Log.debug("ViewController deinitialized — no memory held ✅")
    }
}

