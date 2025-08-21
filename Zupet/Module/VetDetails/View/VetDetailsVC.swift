//
//  VetDetailsVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 20/08/25.
//

import UIKit

class VetDetailsVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel! {
        didSet { lblTitle.font = .manropeBold(18) }
    }
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblVetName: UILabel! { didSet{ lblVetName.font = .manropeBold(18) } }
    @IBOutlet weak var lblLocation: UILabel! { didSet{ lblLocation.font = .manropeRegular(12) } }
    @IBOutlet weak var lblCloseTime: UILabel! { didSet{ lblCloseTime.font = .manropeRegular(12) } }
    @IBOutlet weak var lblOpen: UILabel! { didSet{ lblOpen.font = .manropeRegular(12) } }
    @IBOutlet weak var lblRate: UILabel! { didSet{ lblRate.font = .manropeMedium(12) } }
    
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnAppointment: UIButton!
    @IBOutlet weak var btnReview: UIButton!
    
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var serviceCollection: UICollectionView!
    @IBOutlet weak var serviceCollectionHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var dateCollection: UICollectionView!
    @IBOutlet weak var afternoonSetCollection: UICollectionView!
    @IBOutlet weak var morningSetCollection: UICollectionView!
    
    @IBOutlet weak var lblRateCount: UILabel!{ didSet{ lblRateCount.font = .manropeBold(24) } }
    @IBOutlet weak var rateView: StarRatingView!
    @IBOutlet weak var lblReviewCount: UILabel!{ didSet{ lblReviewCount.font = .manropeMedium(14) } }
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var appointmentView: UIView!
    @IBOutlet weak var reviewView: UIView!
    
    // MARK: - Data
    var photos: [UIImage] = [] // Populate with your images
//    var services: [String] = [] // Populate with service names

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectButton(btnInfo,infoView)
        setupCollections()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
        updateServiceCollectionHeight()
    }
    
    // MARK: - Button Actions
    @IBAction func backOnPress(_ sender: UIButton) { popView() }
    
    @IBAction func infoOnPress(_ sender: UIButton) { selectButton(sender, infoView) }
    @IBAction func appointmentOnPress(_ sender: UIButton) { selectButton(sender,appointmentView) }
    @IBAction func reviewOnPress(_ sender: UIButton) { selectButton(sender,reviewView) }
    
    // MARK: - Button Selection Logic
    private func selectButton(_ selected: UIButton,_ selectedView:UIView) {
        let buttons = [btnInfo, btnAppointment, btnReview]
        let views = [infoView, appointmentView, reviewView]
        
        views.forEach { view in
            if view == selectedView {
                view?.isHidden = false
            }else{
                view?.isHidden = true
            }
        }
        
        buttons.forEach { button in
            if button == selected {
                button?.backgroundColor = .themeOrangeEnd
                button?.setTitleColor(.textWhite, for: .normal)
                button?.titleLabel?.font = .manropeBold(12)
                button?.layer.cornerRadius = 8
                button?.layer.borderWidth = 1
                button?.layer.borderColor = UIColor.clear.cgColor
            } else {
                button?.backgroundColor = .textWhite
                button?.setTitleColor(.textBlack, for: .normal)
                button?.titleLabel?.font = .manropeBold(12)
                button?.layer.cornerRadius = 8
                button?.layer.borderWidth = 1
                button?.layer.borderColor = UIColor.BoarderColor.cgColor
            }
        }
    }
    
    // MARK: - Collection Setup
    private func setupCollections() {
        // Photo Collection
        photoCollection.delegate = self
        photoCollection.dataSource = self
        photoCollection.register(cellType: PhotoXIB.self)
        if let layout = photoCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 8
        }
        
        // Service Collection
        serviceCollection.delegate = self
        serviceCollection.dataSource = self
        serviceCollection.register(cellType: ServiceOfferedXIB.self)
        if let layout = serviceCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
        }
        
        // Morning Set Collection
        morningSetCollection.delegate = self
        morningSetCollection.dataSource = self
        morningSetCollection.register(cellType: TimeXIB.self)
        if let layout = morningSetCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 3
        }
        
        // Afternoon Set Collection
        afternoonSetCollection.delegate = self
        afternoonSetCollection.dataSource = self
        afternoonSetCollection.register(cellType: TimeXIB.self)
        if let layout = afternoonSetCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 3
        }
        
        // Afternoon Set Collection
        dateCollection.delegate = self
        dateCollection.dataSource = self
        dateCollection.register(cellType: DateXIB.self)
        if let layout = dateCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 6
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(cellType: ReviewXIB.self)
        
    }
    
    // MARK: - Dynamic Service Collection Height
    private func updateServiceCollectionHeight() {
        serviceCollection.layoutIfNeeded()
        serviceCollectionHeight.constant = serviceCollection.collectionViewLayout.collectionViewContentSize.height
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension VetDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == photoCollection ? 4 : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == photoCollection {
            let cell : PhotoXIB = collectionView.dequeueReusableCell(for: indexPath)
            cell.lblMore.isHidden = indexPath.item != 3
            cell.imgVet.isHidden = indexPath.item == 3
            return cell
        } else if collectionView == morningSetCollection || collectionView == afternoonSetCollection{
            let cell : TimeXIB = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        }else if collectionView == dateCollection{
            let cell : DateXIB = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        } else {
            let cell : ServiceOfferedXIB = collectionView.dequeueReusableCell(for: indexPath)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle item selection if needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 24) / 4  // 24 = 3 * spacing (8 each)
        if collectionView == photoCollection {
            return CGSize(width: width, height: 86)
        }else if collectionView == morningSetCollection || collectionView == afternoonSetCollection{
            return CGSize(width: width, height: 28)
        }else if collectionView == dateCollection {
            return CGSize(width: width, height: 64)
        }else {
            // Each cell is 1/4 of the collection view width
            return CGSize(width: width, height: 48)
        }
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == serviceCollection {
            updateServiceCollectionHeight()
        }
    }
}

extension VetDetailsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ReviewXIB = tableView.dequeueReusableCell(for: indexPath)
        let data = ["lkn","kljl","jhjkh"]
        cell.configure(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
