//
//  PetCollectionXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 30/08/25.
//

import UIKit

class PetCollectionXIB: UICollectionViewCell {

    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addInnerShadow(cornerRadius: containerView.layer.cornerRadius)
        }
    }
    @IBOutlet weak var addView: UIView!{
        didSet{
            addView.addInnerShadow(cornerRadius: addView.layer.cornerRadius)
        }
    }
    @IBOutlet weak var petView: UIView!{
        didSet{
            petView.addInnerShadow(cornerRadius: petView.layer.cornerRadius)
        }
    }
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
