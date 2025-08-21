//
//  TimeXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 21/08/25.
//

import UIKit

class TimeXIB: UICollectionViewCell {

    @IBOutlet weak var lblTime: UILabel!{
        didSet{
            lblTime.font = .manropeMedium(12)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
