//
//  LanguageXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 27/08/25.
//

import UIKit

class LanguageXIB: UITableViewCell {

    @IBOutlet weak var lblLanguage: UILabel!{
        didSet{
            lblLanguage.font = .manropeRegular(16)
        }
    }
    @IBOutlet weak var imgCheck: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
