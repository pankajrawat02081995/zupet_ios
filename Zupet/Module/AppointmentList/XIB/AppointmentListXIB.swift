//
//  AppointmentListXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 30/08/25.
//

import UIKit

class AppointmentListXIB: UITableViewCell {

    @IBOutlet weak var lblDoctorName: UILabel!{
        didSet{
            lblDoctorName.font = .manropeRegular(14)
        }
    }
    
    @IBOutlet weak var lblDate: UILabel!{
        didSet{
            lblDate.font = .manropeRegular(14)
        }
    }
    
    @IBOutlet weak var lblStatus: UILabel!{
        didSet{
            lblStatus.font = .manropeRegular(14)
        }
    }
    
    @IBOutlet weak var lblPetName: UILabel!{
        didSet{
            lblPetName.font = .manropeRegular(12)
        }
    }
    
    @IBOutlet weak var imgPet: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblPetName.font = .manropeBold(16)
        }
    }
    
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        bgView.addInnerShadow(cornerRadius: bgView.layer.cornerRadius)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
