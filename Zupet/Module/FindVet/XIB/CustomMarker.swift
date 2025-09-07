//
//  CustomMarker.swift
//  Zupet
//
//  Created by Pankaj Rawat on 06/09/25.
//


import UIKit

final class CustomMarker: UIView {
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addInnerShadow(cornerRadius: containerView.layer.cornerRadius)
        }
    }
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!{
        didSet{
            titleLabel.font = .manropeBold(12)
        }
    }

    static func fromNib() -> CustomMarker {
        let nib = UINib(nibName: "CustomMarker", bundle: .main)
        guard let v = nib.instantiate(withOwner: nil, options: nil).first as? CustomMarker else {
            return CustomMarker(frame: CGRect(x:0,y:0,width:40,height:60))
        }
        return v
    }

    func configure(image: String?, title: String? = nil) {
        imageView.setImage(from: image ?? "")
        titleLabel.text = title
        // let autolayout size everything properly
        layoutIfNeeded()
    }
}
