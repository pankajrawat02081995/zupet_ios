//
//  PetCollectionCellXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 10/08/25.
//

import UIKit

class PetCollectionCellXIB: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(data: Pet){
        lblName.text = data.name 
    }
}
