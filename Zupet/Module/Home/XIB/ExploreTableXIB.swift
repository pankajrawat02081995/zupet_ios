//
//  ExploreTableXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 10/08/25.
//

import UIKit

class ExploreTableXIB: UITableViewCell {
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var items: [String] = []
    private let numberOfColumns: CGFloat = 2
    private let cellSpacing: CGFloat = 16
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update height after layout so bounds.width is correct
        updateCollectionHeight()
    }
    
    func configure(with items: [String], tableView: UITableView) {
        self.items = items
        collectionView.reloadData()
        
        DispatchQueue.main.async {
            self.collectionView.layoutIfNeeded()
            self.updateCollectionHeight()
            
            // Trigger tableView to recalc cell height
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    
    private func setupCollectionView() {
        let nib = UINib(nibName: "ExploreCollectionXIB", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ExploreCollectionXIB")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = cellSpacing
            layout.minimumLineSpacing = cellSpacing
        }
    }
    
    private func updateCollectionHeight() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        guard !items.isEmpty else {
            collectionViewHeight.constant = 0
            return
        }
        
        let totalItems = CGFloat(items.count)
        let totalRows = ceil(totalItems / numberOfColumns)
        
        let totalSpacing = layout.minimumLineSpacing * (totalRows - 1)
        let cellWidth = (collectionView.bounds.width - (numberOfColumns - 1) * cellSpacing) / numberOfColumns
        let cellHeight = cellWidth / 1.5
        debugPrint(cellWidth)
        
        collectionViewHeight.constant = (cellHeight * totalRows) + totalSpacing
        debugPrint((cellHeight * totalRows) + totalSpacing)
        debugPrint(totalRows)
    }
}

extension ExploreTableXIB: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreCollectionXIB", for: indexPath) as? ExploreCollectionXIB else {
            return UICollectionViewCell()
        }
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

extension ExploreTableXIB: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - (numberOfColumns - 1) * cellSpacing) / numberOfColumns
        return CGSize(width: width, height: width / 1.5)
    }
}
