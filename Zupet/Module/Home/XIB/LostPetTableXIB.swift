//
//  LostPetTableXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 11/08/25.
//

import UIKit

final class LostPetTableXIB: UITableViewCell {
    
    @IBOutlet private weak var pageIndicator: PageIndicatorView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var items: [String] = [] // Replace String with your model type
    
    var helpPress : ((Int)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        items.removeAll()
        collectionView.reloadData()
        pageIndicator.currentPage = 0
    }
    
    private func setupCollectionView() {
        collectionView.register(cellType: LostPetCollectionXIB.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // In setupCollectionView()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 16 // gap between cells
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) // left/right padding
        }
        
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func configure(with items: [String]) {
        self.items = items
        pageIndicator.numberOfPages = items.count
        pageIndicator.currentPage = 0
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension LostPetTableXIB: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell : LostPetCollectionXIB = collectionView.dequeueReusableCell(for: indexPath)
//        let items = ["asdad","asdasd","asdasd"]
//        cell.configure(with: items[indexPath.item])
        cell.helpPress = { [weak self] index in
            guard self != nil else {return}
            self?.helpPress?(index)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
//extension LostPetTableXIB: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return collectionView.bounds.size // full width per page
//    }
//}

// MARK: - UIScrollViewDelegate
extension LostPetTableXIB: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + (0.5 * pageWidth)) / pageWidth)
        pageIndicator.currentPage = currentPage
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LostPetTableXIB: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 16
        let totalHorizontalInsets: CGFloat = 16 * 2 // left + right section insets
        let availableWidth = collectionView.bounds.width - totalHorizontalInsets - spacing
        return CGSize(width: availableWidth, height: collectionView.bounds.height)
    }
}
