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
    
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblVetName: UILabel! { didSet{ lblVetName.font = .manropeBold(18) } }
    @IBOutlet weak var lblLocation: UILabel! { didSet{ lblLocation.font = .manropeRegular(12) } }
    @IBOutlet weak var lblCloseTime: UILabel! { didSet{ lblCloseTime.font = .manropeRegular(12) } }
    @IBOutlet weak var lblOpen: UILabel! { didSet{ lblOpen.font = .manropeRegular(12) } }
    @IBOutlet weak var lblRate: UILabel! { didSet{ lblRate.font = .manropeMedium(12) } }
    
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnAppointment: UIButton!
    @IBOutlet weak var btnReview: UIButton!
    
    @IBOutlet weak var petCollection: UICollectionView!
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var serviceCollection: UICollectionView!
    @IBOutlet weak var serviceCollectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dateCollection: UICollectionView!
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
    var isDirectAppointment : Bool?
    var petSelectedId : [String]? = []
    var petsData : [PetData]?
    
    private var viewModel : VetDetailsViewModel?
    private var calenderDate : [DaySlot]? = []
    private var slots: [Slot]? = []
    var vetID : String?
    
//    let weekdayDescriptions = [
//        "Monday: 10:00 AM – 5:30 PM",
//        "Tuesday: Open 24 hours",
//        "Wednesday: Closed",
//        "Thursday: 9:00 AM – 12:00 PM, 1:00 PM – 5:00 PM",
//        "Friday: 10:00 AM – 2:00 AM",  // overnight close
//        "Saturday: 10:00 AM – 5:30 PM",
//        "Sunday: Closed"
//    ]
    
    private var selectedDateIndex : Int?
    private var selectedTimeIndex : Int?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = VetDetailsViewModel(view: self, vetID: vetID ?? "")
        viewModel?.getVetDetails()
        
        if isDirectAppointment ?? false{
            selectButton(btnAppointment,appointmentView)
        }else{
            selectButton(btnInfo,infoView)
        }
        setupCollections()
    }
    
    func setupView(){
        let data = viewModel?.vetDetailsModel?.data
        lblRate.text = "\(data?.rating ?? 0.0)"
        lblVetName.text = data?.name ?? ""
        lblLocation.text = data?.address ?? ""
        lblReviewCount.text = "(\(data?.totalReviews ?? 0))+ Reviews"
        lblRateCount.text = "\(data?.rating ?? 0.0)/5.0"
        rateView.rating = data?.rating ?? 0.0
        lblAbout.text = data?.aboutPlace ?? ""
        imgUser.setImage(from: data?.photos?.first ?? "")
        
        calenderDate = SlotGenerator.generateSlots(
            weekdayDescriptions: data?.weekdayDescriptions ?? [],
            days: 7,
            slotMinutes: 30,
            includePastSlotsForToday: true
        )

        slots = calenderDate?.first?.slots ?? []
        
        for d in calenderDate ?? [] {
            print("=== \(d.day) (\(d.date)) closed:\(d.isClosed) ===")
            for s in d.slots {
                print(s.slotTime, s.isAvailable)
            }
        }
        dateCollection.reloadData()
        morningSetCollection.reloadData()
        photoCollection.reloadData()
        serviceCollection.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
        updateServiceCollectionHeight()
        
        Task{
            let petsData = await UserDefaultsManager.shared.get([PetData].self, forKey: UserDefaultsKey.Pets)
            self.petsData = petsData
            petCollection.reloadData()
        }
    }
    
    // MARK: - Button Actions
    @IBAction func calenderOnPress(_ sender: UIButton) {}
    
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
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 6
            layout.minimumInteritemSpacing = 3
        }
        
        // Afternoon Set Collection
        dateCollection.delegate = self
        dateCollection.dataSource = self
        dateCollection.register(cellType: DateXIB.self)
        if let layout = dateCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 6
            layout.minimumInteritemSpacing = 6
        }
        
        petCollection.delegate = self
        petCollection.dataSource = self
        petCollection.register(cellType: PetCollectionXIB.self)
        
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
        if collectionView == petCollection{
            return petsData?.count ?? 0
        }else if collectionView == dateCollection{
            return calenderDate?.count ?? 0
        }else if collectionView == serviceCollection{
            return viewModel?.vetDetailsModel?.data?.services?.count ?? 0
        }else if collectionView == photoCollection{
            return viewModel?.vetDetailsModel?.data?.photos?.count ?? 0
        }else if collectionView == morningSetCollection{
            return slots?.count ?? 0
        }
        return collectionView == photoCollection ? 4 : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == photoCollection {
            let cell : PhotoXIB = collectionView.dequeueReusableCell(for: indexPath)
            let indexData = viewModel?.vetDetailsModel?.data?.photos?[indexPath.row]
            let count = viewModel?.vetDetailsModel?.data?.photos?.count ?? 0
            if count > 3{
                cell.lblMore.isHidden = indexPath.item != (count - 1)
                cell.imgVet.isHidden = indexPath.item == (count - 1)
            }else{
                cell.lblMore.isHidden = true
                cell.imgVet.isHidden = false
            }
            cell.imgVet.setImage(from: indexData ?? "")
            return cell
        } else if collectionView == morningSetCollection {
            let cell : TimeXIB = collectionView.dequeueReusableCell(for: indexPath)
            let indexData = slots?[indexPath.item]
            cell.lblTime.text = indexData?.slotTime ?? ""
            if indexData?.isAvailable == true{
                cell.lblTime.textColor = .textBlack
                cell.lblTime.backgroundColor = .textWhite
                cell.isUserInteractionEnabled = true
            }else{
                cell.lblTime.textColor = .appDarkGray
                cell.lblTime.backgroundColor = .BoarderColor
                cell.isUserInteractionEnabled = false
            }
            if indexPath.item == selectedTimeIndex{
                cell.lblTime.borderColor = .ThemeOrangeEnd
                cell.lblTime.textColor = .ThemeOrangeEnd
            }else{
                cell.lblTime.textColor = .appDarkGray
                cell.lblTime.borderColor = .BoarderColor
            }
            return cell
        }else if collectionView == dateCollection{
            let cell : DateXIB = collectionView.dequeueReusableCell(for: indexPath)
            let indexData = calenderDate?[indexPath.item]
            cell.lblDay.text = indexData?.day ?? ""
            cell.lblDate.text = "\(indexData?.date ?? "")"
            
//            if indexData?.isClosed ?? false == false{
//                cell.lblDay.textColor = .textBlack
//                cell.lblDate.textColor = .textBlack
//                cell.containerView.backgroundColor = .TextWhite
//                cell.isUserInteractionEnabled = true
//            }else{
//                cell.lblDay.textColor = .appDarkGray
//                cell.lblDate.textColor = .appDarkGray
//                cell.containerView.backgroundColor = .BoarderColor
//                cell.isUserInteractionEnabled = false
//            }
            if indexPath.item == selectedDateIndex{
                cell.containerView.borderColor = .ThemeOrangeEnd
                cell.lblDay.textColor = .ThemeOrangeEnd
                cell.lblDate.textColor = .ThemeOrangeEnd
                cell.containerView.backgroundColor = .TextWhite
                cell.isUserInteractionEnabled = true
            }else if indexData?.isClosed ?? false == false{
                cell.lblDay.textColor = .textBlack
                cell.lblDate.textColor = .textBlack
                cell.containerView.backgroundColor = .TextWhite
                cell.containerView.borderColor = .BoarderColor
                cell.isUserInteractionEnabled = true
            }else{
                cell.lblDay.textColor = .appDarkGray
                cell.lblDate.textColor = .appDarkGray
                cell.containerView.backgroundColor = .BoarderColor
                cell.isUserInteractionEnabled = false
            }
            return cell
        }else if collectionView == petCollection{
            let cell : PetCollectionXIB = collectionView.dequeueReusableCell(for: indexPath)
            // Remaining cells are pets
            cell.addView.isHidden = true
            cell.petView.isHidden = false
            cell.imgCheck.isHidden = false
            if let indexData = petsData?[indexPath.item] { // shift by 1
                cell.imgPet.setImage(from: indexData.avatar ?? "",placeholder: UIImage(named: "ic_dummy_nose_scaner"))
                cell.lblPetName.text = indexData.name ?? ""
                cell.lblAge.text = "\(indexData.dob?.shortAge() ?? "0 m") . \(indexData.weight ?? 0)kg"
                if petSelectedId?.contains(indexData.id ?? "") == true{
                    cell.containerView.borderColor = .ThemeOrangeEnd
                    cell.containerView.borderWidth = 1
                    cell.imgCheck.image = .icCheckCircle
                }else{
                    cell.containerView.borderWidth = 0
                    cell.imgCheck.image = .icUncheckCircle
                }
            }
            return cell
        } else {
            let cell : ServiceOfferedXIB = collectionView.dequeueReusableCell(for: indexPath)
            cell.lblService.text = viewModel?.vetDetailsModel?.data?.services?[indexPath.row].name ?? ""
            cell.imgService.setImage(from:viewModel?.vetDetailsModel?.data?.services?[indexPath.row].icon ?? "")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == petCollection{
            if petSelectedId?.contains(petsData?[indexPath.item].id ?? "") == true{
                let index = petSelectedId?.firstIndex(of: petsData?[indexPath.item].id ?? "") ?? 0
                petSelectedId?.remove(at: index)
            }else{
                petSelectedId?.append(petsData?[indexPath.item].id ?? "")
            }
            petCollection.reloadData()
        }else if collectionView == dateCollection{
            selectedDateIndex = indexPath.item
            slots = calenderDate?[indexPath.item].slots
            selectedTimeIndex = nil
            dateCollection.reloadData()
            morningSetCollection.reloadData()
        }else if collectionView == morningSetCollection{
            selectedTimeIndex = indexPath.item
            morningSetCollection.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 24) / 4  // 24 = 3 * spacing (8 each)
        if collectionView == photoCollection {
            return CGSize(width: width, height: 86)
        }else if collectionView == morningSetCollection{
            return CGSize(width: width, height: 28)
        }else if collectionView == dateCollection {
            return CGSize(width: width, height: 64)
        }else if collectionView == petCollection {
            let width = collectionView.bounds.width / 3   // half width
            let height = collectionView.bounds.height     // full height of collection view
            return CGSize(width: width, height: height)
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
        return viewModel?.vetDetailsModel?.data?.reviews?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ReviewXIB = tableView.dequeueReusableCell(for: indexPath)
        if let data = viewModel?.vetDetailsModel?.data?.reviews?[indexPath.row]{
            cell.configure(with: data)
            cell.lblDese.text = data.text ?? ""
            cell.rateView.rating = Double(data.rating ?? 0.0)
            cell.lblName.text = data.authorName ?? "Anonymous"
            cell.lblTime.text = data.timeAgo ?? ""
            cell.lblRate.text = "\(data.rating ?? 0)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
