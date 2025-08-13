//
//  HomeVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 05/08/25.
//

import UIKit

class HomeVC: UIViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
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

}

// MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5 // Only one section for now
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Only PetTableCellXIB for now
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableCellXIB", for: indexPath) as? PetTableCellXIB else {
                return UITableViewCell()
            }
            cell.configure(with: petList)
            return cell
        }else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTableXIB", for: indexPath) as? ExploreTableXIB else {
                return UITableViewCell()
            }
            let apiData = ["Mood Check", "Talk to me", "GPS Tracker", "Find a Vet"]
            cell.configure(with: apiData, tableView: tableView)
            return cell
        }else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentActivityTableXIB", for: indexPath) as? RecentActivityTableXIB else {
                return UITableViewCell()
            }
            let apiData = ["Mood Check", "Talk to me", "GPS Tracker", "Find a Vet"]
            cell.configure(with: apiData)
            cell.onHeightChange = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
            return cell
        }else if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AboutPetTableXIB", for: indexPath) as? AboutPetTableXIB else {
                return UITableViewCell()
            }
            
            return cell
        }else if indexPath.section == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LostPetTableXIB", for: indexPath) as? LostPetTableXIB else {
                return UITableViewCell()
            }
            cell.configure(with: ["asdad","asdasd","asdasd"])
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
