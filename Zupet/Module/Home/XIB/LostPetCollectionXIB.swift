//
//  LostPetCollectionXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 11/08/25.
//

import UIKit

class LostPetCollectionXIB: UICollectionViewCell {

    @IBOutlet weak var btnHelp: UIButton!
    @IBOutlet weak var lblSubTitle: UILabel!{
        didSet{
            lblSubTitle.font = .manropeMedium(12)
        }
    }
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeBold(16)
        }
    }
    @IBOutlet weak var imgPet: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func helpOnPress(_ sender: UIButton) {
    }
}
