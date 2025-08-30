//
//  PetCollectionXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 30/08/25.
//

import UIKit

class PetCollectionXIB: UICollectionViewCell {

    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var petView: UIView!
    @IBOutlet weak var imgPet: UIImageView!
    @IBOutlet weak var lblAge: UILabel!{
        didSet{
            lblAge.font = .manropeRegular(14)
        }
    }
    @IBOutlet weak var lblPetName: UILabel!{
        didSet{
            lblPetName.font = .manropeBold(14)
        }
    }
    @IBOutlet weak var lblAddPet: UILabel!{
        didSet{
            lblAddPet.font = .manropeBold(14)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
