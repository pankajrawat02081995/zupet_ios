//
//  AppointmentTimelineXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 30/08/25.
//

import UIKit

class AppointmentTimelineXIB: UITableViewCell {

    @IBOutlet weak var btnDecline: UIButton!{
        didSet{
            btnDecline.addInnerShadow(cornerRadius: btnDecline.layer.cornerRadius)
        }
    }
    @IBOutlet weak var btnAccept: UIButton!{
        didSet{
            btnAccept.addInnerShadow(cornerRadius: btnAccept.layer.cornerRadius)
        }
    }
    @IBOutlet weak var timelineView: UIView!
    @IBOutlet weak var lblSubtitle: UILabel!{
        didSet{
            lblSubtitle.font = .manropeRegular(12)
        }
    }
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeBold(14)
        }
    }
    @IBOutlet weak var imgTimeline: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
