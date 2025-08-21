//
//  ReviewXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 21/08/25.
//

import UIKit

class ReviewXIB: UITableViewCell {

    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblName: UILabel! {
        didSet { lblName.font = .manropeBold(16) }
    }
    @IBOutlet weak var lblTime: UILabel! {
        didSet { lblTime.font = .manropeMedium(12) }
    }
    @IBOutlet weak var lblRate: UILabel! {
        didSet { lblRate.font = .manropeMedium(12) }
    }
    @IBOutlet weak var rateView: StarRatingView!
    @IBOutlet weak var lblDese: UILabel! {
        didSet { lblDese.font = .manropeMedium(12) }
    }
    @IBOutlet weak var imgUser: UIImageView!
    
    private var reviews: [String] = [] // replace `Review` with your model

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: PhotoXIB.self) // replace with your custom cell
        collectionViewHeight.constant = 0 // default hidden
    }

    func configure(with reviews: [String]) {
        self.reviews = reviews
        collectionView.reloadData()
        
        // Set height based on data
        collectionViewHeight.constant = reviews.isEmpty ? 0 : 72
    }
}

// MARK: - Collection View
extension ReviewXIB: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PhotoXIB = collectionView.dequeueReusableCell(for: indexPath)
        // configure your cell with `reviews[indexPath.item]`
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 3) - 10, height: collectionView.bounds.height) // adjust as needed
    }
}
