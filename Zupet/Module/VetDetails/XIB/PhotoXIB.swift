//
//  PhotoXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 20/08/25.
//

import UIKit

class PhotoXIB: UICollectionViewCell {

    @IBOutlet weak var lblMore: UILabel!{
        didSet{
            lblMore.font = .manropeBold(12)
        }
    }
    @IBOutlet weak var imgVet: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
