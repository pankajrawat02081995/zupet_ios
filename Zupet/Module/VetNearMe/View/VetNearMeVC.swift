//
//  VetNearMeVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 19/08/25.
//

import UIKit

final class VetNearMeVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var txtSeach: UITextField! {
        didSet {
            txtSeach.font = .manropeMedium(14)
        }
    }
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var lblTitle: UILabel! {
        didSet {
            lblTitle.font = .manropeBold(18)
        }
    }
    
    // MARK: - Properties
    private var vets: [String] = []  // replace String with your Vet model later
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        collectionView.register(cellType: VetXIB.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        // Smooth scrolling
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 12
            layout.minimumInteritemSpacing = 8
            layout.estimatedItemSize = .zero // prevents auto-sizing stutters
        }
    }
    
    // MARK: - Actions
    @IBAction private func backOnPress(_ sender: UIButton) {
        popView()
    }
}

// MARK: - UICollectionViewDataSource
extension VetNearMeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : VetXIB = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VetNearMeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle vet selection
        push(VetDetailsVC.self, from: .vet)
    }
}
