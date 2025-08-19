//
//  VetXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 18/08/25.
//

import UIKit

class VetXIB: UICollectionViewCell {

    @IBOutlet weak var lblRate: UILabel!{
        didSet{
            lblRate.font = .manropeMedium(10)
        }
    }
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            lblName.font = .manropeBold(14)
        }
    }
    @IBOutlet weak var lblAddress: UILabel!{
        didSet{
            lblAddress.font = .manropeMedium(10)
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblCloseTime: UILabel!{
        didSet{
            lblCloseTime.font = .manropeMedium(10)
        }
    }
    @IBOutlet weak var lblOpen: UILabel!{
        didSet{
            lblOpen.font = .manropeMedium(10)
        }
    }
    @IBOutlet weak var lblBookNow: UILabel!{
        didSet{
            lblBookNow.font = .manropeRegular(12)
        }
    }
    @IBOutlet weak var imgUser: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
