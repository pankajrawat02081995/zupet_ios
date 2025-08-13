//
//  DailyChallangeXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 12/08/25.
//

import UIKit

final class DailyChallangeXIB: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var imgPet: UIImageView!
    @IBOutlet private weak var btnChallenge: UIButton! {
        didSet {
            // Apply gradient once; update frame only when layout changes
            btnChallenge.applyDiagonalGradient()
        }
    }
    @IBOutlet private weak var lblSubTitle: UILabel! {
        didSet {
            lblSubTitle.font = .manropeLight(14)
        }
    }
    @IBOutlet private weak var lblTitle: UILabel! {
        didSet {
            lblTitle.font = .manropeBold(24)
        }
    }
    
    // MARK: - Callbacks
    var onChallengeTap: (() -> Void)?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update gradient frame if needed
        btnChallenge.updateGradientFrameIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgPet.image = nil
        lblTitle.text = nil
        lblSubTitle.text = nil
        onChallengeTap = nil
    }
    
    // MARK: - Configuration
    /// Updates all UI elements in one call
    func configure(image: UIImage?,
                   subtitle: String,
                   onTap: (() -> Void)? = nil) {
        imgPet.image = image
        lblSubTitle.text = subtitle
        onChallengeTap = onTap
    }
    
    // MARK: - Actions
    @IBAction private func challangeOnPress(_ sender: UIButton) {
        onChallengeTap?()
    }
}
