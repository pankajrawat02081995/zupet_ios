//
//  PetSelectionXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 31/07/25.
//

import UIKit

class PetSelectionXIB: UICollectionViewCell {

    @IBOutlet weak var imgPet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with page: PetSelection) {
        imgPet.image = UIImage(named: page.isSelected ? page.imageSelectedName : page.imageName)
    }
}
