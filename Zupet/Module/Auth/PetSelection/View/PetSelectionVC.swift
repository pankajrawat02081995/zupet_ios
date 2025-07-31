//
//  PetSelectionVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 31/07/25.
//

import UIKit

struct PetSelection {
    let imageName: String
    let imageSelectedName: String
    var isSelected: Bool
}

class PetSelectionVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var pageController: PageIndicatorView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    private var pages: [PetSelection] = [
        PetSelection(imageName: "ic_small_dog_grey", imageSelectedName: "ic_small_dog", isSelected: false),
        PetSelection(imageName: "ic_small_cat_grey", imageSelectedName: "ic_small_cat", isSelected: false)
    ]

    private let cellSpacing: CGFloat = 16
    private let horizontalMargin: CGFloat = 18

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        updateContinueButtonState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Apply diagonal gradient to btnContinue button and background view
        btnContinue.applyDiagonalGradient()
        btnContinue.updateGradientFrameIfNeeded()

        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }

    private func setupCollectionView() {
        collectionView.register(cellType: PetSelectionXIB.self)

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = cellSpacing
            layout.sectionInset = UIEdgeInsets(top: 0, left: horizontalMargin, bottom: 0, right: horizontalMargin)
        }

        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self

        pageController.numberOfPages = pages.count
        pageController.currentPage = 0
    }

    @IBAction func continueOnPress(_ sender: UIButton) {
        push(PetNoseScanerVC.self, from: .main)
    }

    private func updateContinueButtonState() {
        let isAnySelected = pages.contains(where: { $0.isSelected })

        btnContinue.isEnabled = isAnySelected
        btnContinue.alpha = isAnySelected ? 1.0 : 0.5 // visually show enabled/disabled
    }

    
    deinit {
        Log.debug("PetSelectionVC deinitialized")
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
}

// MARK: - CollectionView Delegates

extension PetSelectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PetSelectionXIB = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: pages[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (collectionView.bounds.width - (horizontalMargin * 2 + cellSpacing)) / 2
        return CGSize(width: width, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<pages.count {
            pages[i].isSelected = (i == indexPath.item)
        }
        
        collectionView.reloadData()
        updateContinueButtonState() // 👈 important
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageController.currentPage = page
    }
}


