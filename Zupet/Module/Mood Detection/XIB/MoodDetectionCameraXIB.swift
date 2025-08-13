//
//  MoodDetectionCameraXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 11/08/25.
//

import UIKit

class MoodDetectionCameraXIB: UITableViewCell {

    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var lblSubtitle: UILabel!{didSet{
        lblSubtitle.font = .manropeMedium(12)
    }}
    @IBOutlet weak var lblTitle: UILabel!{didSet{
        lblTitle.font = .manropeBold(24)
    }}
    @IBOutlet weak var cameraView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
