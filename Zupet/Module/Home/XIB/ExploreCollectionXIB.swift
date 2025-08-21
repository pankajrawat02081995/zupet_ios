//
//  ExploreCollectionXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 10/08/25.
//

import UIKit

class ExploreCollectionXIB: UICollectionViewCell {
    
    @IBOutlet weak var imgExplore: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeMedium(14)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with explore: ExploreItem) {
        lblTitle.text = explore.title
        imgExplore.setImage(from: explore.icon)
    }
    
}
