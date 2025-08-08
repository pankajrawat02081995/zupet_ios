//
//  OnboardingVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 22/07/25.
//

import UIKit

struct OnboardingPage {
    let imageName: String
    let title: String
    let subtitle: String
}

final class OnboardingVC: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageIndicator: PageIndicatorView!
    @IBOutlet private weak var btnNext: UIButton!
    
    private let pages: [OnboardingPage] = [
        .init(imageName: "ic_dog3", title: "Know Your Dog’s Mood", subtitle: "Real-time AI reads emotions through posture and behavior."),
        .init(imageName: "ic_location_tracker", title: "Track in Real-Time", subtitle: "GPS tags help monitor walks, location, and safety."),
        .init(imageName: "ic_lost_pet", title: "Instant Pet Alerts", subtitle: "Lost pet? Nearby users and vets get notified fast.")
    ]
    
    private var currentPage = 0 {
        didSet {
            pageIndicator.currentPage = currentPage
            btnNext.setTitle(currentPage == pages.count - 1 ? "Get Started" : "Next", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        currentPage = 0
    }
    
    private func setupCollectionView() {
        collectionView.register(cellType: OnboardingXIB.self)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageIndicator.numberOfPages = pages.count
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = collectionView.bounds.size
        }
    }
    
    @IBAction private func nextOnPress(_ sender: UIButton) {
        if currentPage == pages.count - 1 {
            moveToNextScreen()
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func moveToNextScreen() {
        set(SignInVC.self, from: .main)
    }
    
    deinit {
        Log.debug("OnboardingVC deinitialized")
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
}

extension OnboardingVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingXIB = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: pages[indexPath.item])
        return cell
    }
}

extension OnboardingVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        if page != currentPage {
            currentPage = page
        }
    }
}
