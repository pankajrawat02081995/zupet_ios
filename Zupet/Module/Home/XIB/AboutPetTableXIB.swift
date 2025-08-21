//
//  AboutPetTableXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 10/08/25.
//

import UIKit

final class AboutPetTableXIB: UITableViewCell {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!

    private var items: [AboutItem] = [] // Replace String with your model if needed
    private let numberOfColumns: CGFloat = 3
    private let cellSpacing: CGFloat = 16

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        items.removeAll()
        collectionView.reloadData()
    }

    private func setupCollectionView() {
        collectionView.register(cellType: AboutPetCollectionXIB.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }

    func configure(with items: [AboutItem], title: String) {
        self.items = items
        lblTitle.text = title
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension AboutPetTableXIB: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell : AboutPetCollectionXIB = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(aboutItem: items[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AboutPetTableXIB: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let totalSpacing = (numberOfColumns - 1) * cellSpacing
        let availableWidth = collectionView.bounds.width - totalSpacing
        let cellWidth = floor(availableWidth / numberOfColumns)

        // Height can be same as width or custom
        return CGSize(width: cellWidth, height: 74)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
