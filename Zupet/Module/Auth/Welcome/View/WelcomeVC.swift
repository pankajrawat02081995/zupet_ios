//
//  WelcomeVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 01/08/25.
//

import UIKit

class WelcomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start 2-second delayed navigation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.navigateToNextVC()
        }
    }
    
    private func navigateToNextVC() {
        // Replace "NextViewController" with your actual destination VC class
        push(TabbarVC.self, from: .tabbar)
    }
}
