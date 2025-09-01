//
//  ProfileVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 24/08/25.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var lblMyApploitmentTitle: UILabel!{
        didSet{
            lblMyApploitmentTitle.font = .manropeRegular(14)
        }
    }
    @IBOutlet weak var lblRemonderTitle: UILabel!{
        didSet{
            lblRemonderTitle.font = .manropeRegular(14)
        }
    }
    @IBOutlet weak var lblJourneyTitle: UILabel!{
        didSet{
            lblJourneyTitle.font = .manropeBold(14)
        }
    }
    @IBOutlet weak var lblFeaturesTitle: UILabel!{
        didSet{
            lblFeaturesTitle.font = .manropeBold(14)
        }
    }
    @IBOutlet weak var lblPetTitle: UILabel!{
        didSet{
            lblPetTitle.font = .manropeBold(14)
        }
    }
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeBold(18)
        }
    }
    @IBOutlet weak var lblEmail: UILabel!{
        didSet{
            lblEmail.font = .manropeRegular(14)
        }
    }
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            lblName.font = .manropeBold(24)
        }
    }
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var bgView: UIView!
    
    private var viewModel : ProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProfileViewModel(view: self)
        setupCollectionView()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.getProfileData()
    }
    
    func setupData(){
        Task{ [weak self] in
            guard let self = self else{ return}
            let user = viewModel?.profileModel
            self.lblName.text = user?.data?.fullName ?? ""
            self.lblEmail.text = user?.data?.email ?? ""
            self.imgUser.setImage(from: user?.data?.avatar ?? "")
        }
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: PetCollectionXIB.self)
    }
    
    private func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(cellType: JourneyXIB.self)
    }
    
    func updateTableViewHeight() {
        tableView.layoutIfNeeded() // make sure contentSize is updated
        tableViewHeight.constant = tableView.contentSize.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
        // Apply diagonal gradient to btnContinue button and background view
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    @IBAction func settingOnPress(_ sender: UIButton) {
        push(SettingVC.self, from: .profile)
    }
    
    @IBAction func appoitmentOnPress(_ sender: UIButton) {
        push(AppointmentListVC.self, from: .profile)
    }
    
    @IBAction func reminderOnPress(_ sender: UIButton) {
    }
}

extension ProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel?.petModel?.data?.count ?? 0
        if count == 0 {
            return 1 // Only "Add" cell
        }
        return count + 1 // Add cell + pets
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PetCollectionXIB = collectionView.dequeueReusableCell(for: indexPath)
        
        if indexPath.item == 0 {
            // First cell is always "Add New"
            cell.addView.isHidden = false
            cell.petView.isHidden = true
        } else {
            // Remaining cells are pets
            cell.addView.isHidden = true
            cell.petView.isHidden = false
            if let indexData = viewModel?.petModel?.data?[indexPath.item - 1] { // shift by 1
                cell.imgPet.setImage(from: indexData.avatar ?? "",placeholder: UIImage(named: "ic_dummy_nose_scaner"))
                cell.lblPetName.text = indexData.name ?? ""
                cell.lblAge.text = "\(indexData.dob?.shortAge() ?? "0 m") . \(indexData.weight ?? 0)kg"
            }
        }
        
        return cell
    }

    
    // 🔹 Cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width / 3   // half width
        let height = collectionView.bounds.height     // full height of collection view
        return CGSize(width: width, height: height)
    }
    
    // (optional) spacing between cells
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            push(PetSelectionVC.self, from: .main)
        }else{
            
        }
    }
    
}

extension ProfileVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.profileModel?.data?.journey.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : JourneyXIB = tableView.dequeueReusableCell(for: indexPath)
        let indexData = viewModel?.profileModel?.data?.journey[indexPath.row]
        cell.lblTitle.text = indexData?.title ?? ""
        cell.lblSubtitle.text = indexData?.value ?? ""
        if indexData?.title == "Community Impact:"{
            cell.lblSubtitle.textColor = .fromHex("#329D52")
        }else{
            cell.lblSubtitle.textColor = .textBlack
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
