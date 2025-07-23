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

class OnboardingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageIndicator: PageIndicatorView!
    @IBOutlet weak var btnNext: UIButton!
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(imageName: "ic_dog3", title: "Know Your Dog’s Mood", subtitle: "Real-time AI reads emotions through posture and behavior."),
        OnboardingPage(imageName: "ic_location_tracker", title: "Track in Real-Time", subtitle: "GPS tags help monitor walks, location, and safety."),
        OnboardingPage(imageName: "ic_lost_pet", title: "Instant Pet Alerts", subtitle: "Lost pet? Nearby users and vets get notified fast.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        updateButtonTitle(for: 0)
    }
    
    private func setupCollectionView() {
        collectionView.register(cellType: OnboardingXIB.self)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageIndicator.numberOfPages = pages.count
        pageIndicator.currentPage = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func nextOnPress(_ sender: UIButton) {
        let nextPage = min(pageIndicator.currentPage + 1, pages.count - 1)
        
        if pageIndicator.currentPage == pages.count - 1 {
            // Move to next screen
            moveToNextScreen()
        } else {
            let indexPath = IndexPath(item: nextPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            pageIndicator.currentPage = nextPage
            updateButtonTitle(for: nextPage)
        }
    }
    
    private func updateButtonTitle(for index: Int) {
        btnNext.setTitle(index == pages.count - 1 ? "Get Started" : "Next", for: .normal)
    }
    
    private func moveToNextScreen() {
        // Example navigation to next screen
        //        let nextVC = HomeVC() // Replace with actual VC
        //        navigationController?.pushViewController(nextVC, animated: true)
        
        // Clean up memory
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
    
    // MARK: ScrollView
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageIndicator.currentPage = page
        updateButtonTitle(for: page)
    }
    
    // MARK: CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingXIB = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: pages[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    deinit {
        Log.debug("OnboardingVC deinitialized")
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
}
