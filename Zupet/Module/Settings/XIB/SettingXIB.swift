//
//  SettingXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 25/08/25.
//

import UIKit

class SettingXIB: UITableViewCell {

    @IBOutlet weak var imgNext: UIImageView!
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgSetting: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
