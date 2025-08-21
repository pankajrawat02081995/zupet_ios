//
//  AboutPetCollectionXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 11/08/25.
//

import UIKit

class AboutPetCollectionXIB: UICollectionViewCell {

    @IBOutlet weak var lblSubtitle: UILabel!{
        didSet{
            lblSubtitle.font = .manropeBold(16)
        }
    }
    
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeMedium(14)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    func configure(aboutItem:AboutItem){
//        lblTitle.text = aboutItem.title 
//        lblSubtitle.text = "\(aboutItem.dese ?? 0)"
//    }

}
