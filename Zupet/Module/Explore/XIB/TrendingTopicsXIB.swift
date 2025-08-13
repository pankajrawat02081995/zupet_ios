//
//  TrendingTopicsXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 14/08/25.
//

import UIKit

class TrendingTopicsXIB: UITableViewCell {

    @IBOutlet weak var lblViews: UILabel!{
        didSet{
            lblViews.font = .manropeRegular(12)
        }
    }
    @IBOutlet weak var lblSubTitle: UILabel!{
        didSet{
            lblSubTitle.font = .manropeRegular(14)
        }
    }
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeBold(14)
        }
    }
    @IBOutlet weak var imgPet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
