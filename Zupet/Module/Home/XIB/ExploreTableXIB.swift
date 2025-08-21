//
//  ExploreTableXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 10/08/25.
//

import UIKit

enum ExploreType{
    case FindVeterinary
    case MoodChecker
}

class ExploreTableXIB: UITableViewCell {
    
    @IBOutlet weak var imgExplore: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTop: NSLayoutConstraint!
    @IBOutlet weak var imgExploreHieght: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var items: [ExploreItem] = []
    private let numberOfColumns: CGFloat = 2
    private let cellSpacing: CGFloat = 16
    
    var isExploreTaped : ((ExploreType)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update height after layout so bounds.width is correct
        updateCollectionHeight()
    }
    
    func configure(with items: [ExploreItem], tableView: UITableView,isHome:Bool=true) {
        self.items = items
        collectionView.reloadData()
        
        DispatchQueue.main.async {
            if isHome == false{
                self.lblTitle.text = ""
                self.imgExploreHieght.constant = 0
                self.collectionViewTop.constant = 0
            }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0{
            isExploreTaped?(.MoodChecker)
        }else if indexPath.item == 3{
            isExploreTaped?(.FindVeterinary)
        }
    }
}
