//
//  PetTableCellXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 10/08/25.
//

import UIKit

class PetTableCellXIB: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageIndicator: PageIndicatorView!
    
    private var pets: [Pet] = [] // Replace String with your Pet model if needed
    private var cellWidth: CGFloat = 0
    var petID : ((String)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    // MARK: - Public Setup Method
    func configure(with pets: [Pet]) {
        self.pets = pets
        pageIndicator.numberOfPages = pets.count   // ✅ number of inner
        pageIndicator.currentPage = 0
        collectionView.reloadData()
        
        // Layout update after reload to ensure correct sizing
        DispatchQueue.main.async { [weak self] in
            self?.updateCellWidth()
        }
    }
        
        // MARK: - Collection View Setup
        private func setupCollectionView() {
            collectionView.register(cellType: PetCollectionCellXIB.self)
            collectionView.dataSource = self
            collectionView.delegate = self
            
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.isPagingEnabled = true // We'll use snapping manually
            collectionView.decelerationRate = .fast
            
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
            }
        }
        
        private func updateCellWidth() {
            cellWidth = collectionView.bounds.width
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

// MARK: - UICollectionView DataSource
extension PetTableCellXIB: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCollectionCellXIB", for: indexPath) as? PetCollectionCellXIB else {
            return UICollectionViewCell()
        }
        let pets = pets[indexPath.item]
        // Configure your cell here
         cell.config(data: pets)
        return cell
    }
}

// MARK: - UICollectionView DelegateFlowLayout
extension PetTableCellXIB: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }
}

// MARK: - UIScrollViewDelegate for Page Indicator
extension PetTableCellXIB: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentPage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateCurrentPage()
        }
    }
    
    private func updateCurrentPage() {
        let page = Int(round(collectionView.contentOffset.x / cellWidth))
        pageIndicator.currentPage = page
        petID?(pets[page].id)
    }
}

