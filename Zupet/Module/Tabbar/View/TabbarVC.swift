//
//  TabbarVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 04/08/25.
//

import UIKit

class TabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply corner radius
        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = false // Make sure shadow shows
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Top left and top right corners only

        // Apply shadow
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 10
        tabBar.layer.backgroundColor = UIColor.white.cgColor // Required for shadow to appear well on some backgrounds

        // Optional: Prevent the tab bar from extending under the safe area
        tabBar.layer.shouldRasterize = true
        tabBar.layer.rasterizationScale = UIScreen.main.scale
    }
}

