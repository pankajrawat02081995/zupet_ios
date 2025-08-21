//
//  DateXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 21/08/25.
//

import UIKit

class DateXIB: UICollectionViewCell {

    @IBOutlet weak var lblDate: UILabel!{
        didSet{
            lblDate.font = .manropeBold(18)
        }
    }
    @IBOutlet weak var lblDay: UILabel!{
        didSet{
            lblDay.font = .manropeMedium(12)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
