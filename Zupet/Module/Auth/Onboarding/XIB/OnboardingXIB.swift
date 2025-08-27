//
//  OnboardingXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 22/07/25.
//

import UIKit

class OnboardingXIB: UICollectionViewCell {
    
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgOnBoarding: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with page: OnboardingPage) {
        imgOnBoarding.image = UIImage(named: page.imageName)
        lblTitle.localize(page.title)
        lblSubTitle.localize(page.subtitle)
    }
}
