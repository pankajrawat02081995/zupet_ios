//
//  JourneyXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 30/08/25.
//

import UIKit

class JourneyXIB: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeRegular(14)
        }
    }
    @IBOutlet weak var lblSubtitle: UILabel!{
        didSet{
            lblSubtitle.font = .manropeBold(14)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
