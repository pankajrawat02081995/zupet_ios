//
//  CustomMarkerView.swift
//  Zupet
//
//  Created by Pankaj Rawat on 14/08/25.
//

//import Foundation
//
//class CustomMarkerView: UIView {
//    
//    @IBOutlet weak var userImageView: UIImageView!
//    @IBOutlet weak var ratingLabel: UILabel!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setupView()
//    }
//    
//    private func setupView() {
//        userImageView.layer.cornerRadius = userImageView.frame.width / 2
//        userImageView.clipsToBounds = true
//        ratingLabel.textColor = .orange
//        ratingLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
//    }
//    
//    func configure(image: UIImage, rating: Double) {
//        userImageView.image = image
//        ratingLabel.text = String(format: "%.1f", rating)
//    }
//}
