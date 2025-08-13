//
//  ActivityTableXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 10/08/25.
//

import UIKit

class ActivityTableXIB: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!{
        didSet{
            lblTime.font = .manropeRegular(12)
        }
    }
    
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTime.font = .manropeRegular(14)
        }
    }
    
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
