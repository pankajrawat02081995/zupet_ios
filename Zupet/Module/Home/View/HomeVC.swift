//
//  HomeVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 05/08/25.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            Task{
                lblTitle.text = "Hello \(await UserDefaultsManager.shared.fatchCurentUser()?.fullName ?? "")"
            }
        }
    }
    
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgView: UIView!
    private var petList: [String] = ["Pet1", "Pet2", "Pet3"] // Replace with your model later
    private var viewModel : HomeViewModel?
    var petID : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel(view: self)
        setupTableView()
        viewModel?.callHomeApi()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Apply diagonal gradient to btnContinue button and background view
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    // MARK: - Table View Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        // Register PetTableCellXIB
        //          let nib = UINib(nibName: "PetTableCellXIB", bundle: nil)
        //          tableView.register(nib, forCellReuseIdentifier: "PetTableCellXIB")
        tableView.register(cellType: PetTableCellXIB.self)
        tableView.register(cellType: ExploreTableXIB.self)
        tableView.register(cellType: RecentActivityTableXIB.self)
        tableView.register(cellType: AboutPetTableXIB.self)
        tableView.register(cellType: LostPetTableXIB.self)
        
        // Auto height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }

    @IBAction func imgUserOnPress(_ sender: UIButton) {
        presentPopup(from: self, mainTitle: .Logout, subTitle: .Logout, btnOkTitle: .Yes, btnCancelTitle: .No) {
            self.viewModel?.callLogoutApi()
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.homeModel?.getAllSections().count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionKey = viewModel?.homeModel?.getAllSections()[section] else {
            return 0
        }
        
        switch sectionKey {
        case "homeSection":
            // Example: return count from your model
            return viewModel?.homeModel?.getSections(for: self.petID ?? "").count ?? 0
            
        case "lostSection":
            return 1
            
        default:
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let sectionKey = viewModel?.homeModel?.getAllSections()[indexPath.section] else {
            return UITableViewCell()
        }
        
        switch sectionKey {
        case "homeSection":
            guard let rowKey = viewModel?.homeModel?.getSections(for: self.petID ?? "" )[indexPath.row] else {
                return UITableViewCell()
            }
            
            switch rowKey {
            case "petCardSection":
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableCellXIB", for: indexPath) as? PetTableCellXIB else {
                    return UITableViewCell()
                }
                let index = viewModel?.homeModel?.getAllPets().firstIndex { pet in
                    pet.id == self.petID ?? ""
                }
                cell.configure(with: viewModel?.homeModel?.getAllPets() ?? [], index: index ?? 0)
                cell.petID = { [weak self] id in
                    guard let self = self else {return}
                    self.petID = id
                    self.tableView.reloadData()
                }
                return cell
            case "exploreSection":
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTableXIB", for: indexPath) as? ExploreTableXIB else {
                    return UITableViewCell()
                }
                cell.configure(with: viewModel?.homeModel?.getExplore(for: self.petID ?? "") ?? [], tableView: tableView)
                cell.isExploreTaped = { [weak self] exploreType in
                    guard self != nil else {return}
                    if exploreType == .FindVeterinary{
                        self?.push(FindVetVC.self, from: .vet)
                    }else if exploreType == .MoodChecker{
                        self?.push(MoodDetectionVC.self, from: .home)
                    }
                }
                return cell
            case "recentActivitySection":
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentActivityTableXIB", for: indexPath) as? RecentActivityTableXIB else {
                    return UITableViewCell()
                }
                cell.configure(with: viewModel?.homeModel?.getRecentActivity(for: self.petID ?? "") ?? [])
                cell.onHeightChange = { [weak self] in
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                }
                return cell
            case "aboutSection":
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AboutPetTableXIB", for: indexPath) as? AboutPetTableXIB else {
                    return UITableViewCell()
                }
                cell.configure(with: viewModel?.homeModel?.getAbout(for: self.petID ?? "") ?? [], title: "About \(viewModel?.homeModel?.getPetDetails(by: self.petID ?? "")?.name ?? "")")
                return cell
            default:
                break
            }
            
        case "lostSection":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LostPetTableXIB", for: indexPath) as? LostPetTableXIB else {
                return UITableViewCell()
            }
            cell.configure(with: ["asdad","asdasd","asdasd"])
            cell.helpPress = { [weak self] index in
                guard self != nil else {return}
                self?.push(LostPetAlertVC.self, from: .home)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
        
        
        
        
        
        //        if indexPath.section == 0{
        //            if indexPath.row == 0 {
        //                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableCellXIB", for: indexPath) as? PetTableCellXIB else {
        //                    return UITableViewCell()
        //                }
        ////                cell.configure(with: viewModel?.homeModel?.allPets() ?? [])
        //                cell.petID = { [weak self] id in
        //                    guard let self = self else {return}
        //                    self.viewModel?.getPetData(petID: id)
        //                }
        //                return cell
        //            }else if indexPath.row == 1 {
        //                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTableXIB", for: indexPath) as? ExploreTableXIB else {
        //                    return UITableViewCell()
        //                }
        //                let apiData = ["Mood Check", "Talk to me", "GPS Tracker", "Find a Vet"]
        //                cell.configure(with: apiData, tableView: tableView)
        //                cell.isExploreTaped = { [weak self] exploreType in
        //                    guard self != nil else {return}
        //                    if exploreType == .FindVeterinary{
        //                        self?.push(FindVetVC.self, from: .vet)
        //                    }else if exploreType == .MoodChecker{
        //                        self?.push(MoodDetectionVC.self, from: .home)
        //                    }
        //                }
        //                return cell
        //            }else if indexPath.row == 2 {
        //                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentActivityTableXIB", for: indexPath) as? RecentActivityTableXIB else {
        //                    return UITableViewCell()
        //                }
        //                let apiData = ["Mood Check", "Talk to me", "GPS Tracker", "Find a Vet"]
        //                cell.configure(with: apiData)
        //                cell.onHeightChange = { [weak self] in
        //                    self?.tableView.beginUpdates()
        //                    self?.tableView.endUpdates()
        //                }
        //                return cell
        //            }else if indexPath.row == 3 {
        //                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AboutPetTableXIB", for: indexPath) as? AboutPetTableXIB else {
        //                    return UITableViewCell()
        //                }
        //
        //                return cell
        //            }
        //        }
        //        else if  indexPath.section == 1 {
        //            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LostPetTableXIB", for: indexPath) as? LostPetTableXIB else {
        //                return UITableViewCell()
        //            }
        //            cell.configure(with: ["asdad","asdasd","asdasd"])
        //            cell.helpPress = { [weak self] index in
        //                guard self != nil else {return}
        //                self?.push(LostPetAlertVC.self, from: .home)
        //            }
        //            return cell
        //        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
