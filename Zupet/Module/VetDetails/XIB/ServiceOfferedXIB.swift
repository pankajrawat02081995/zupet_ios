//
//  ServiceOfferedXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 20/08/25.
//

import UIKit

class ServiceOfferedXIB: UICollectionViewCell {

    @IBOutlet weak var lblService: UILabel!{
        didSet{
            lblService.font = .manropeRegular(12)
        }
    }
    @IBOutlet weak var imgService: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
