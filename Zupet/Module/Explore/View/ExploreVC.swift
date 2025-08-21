//
//  ExploreVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 12/08/25.
//

import UIKit

final class ExploreVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var lblTitle: UILabel! {
        didSet {
            lblTitle.font = .manropeBold(18)
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    
    @IBOutlet private weak var bgView: UIView!
    
    // MARK: - Data
    private var items: [String] = [
        "Explore item 1",
        "Explore item 2",
        "Explore item 3"
    ]
    
    // To avoid reapplying gradient unnecessarily
    private var lastBgViewSize: CGSize = .zero
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Apply gradient only when size changes (better performance)
        if bgView.bounds.size != lastBgViewSize {
            lastBgViewSize = bgView.bounds.size
            bgView.applyDiagonalGradient()
            bgView.updateGradientFrameIfNeeded()
        }
    }
}

// MARK: - Table View Setup
private extension ExploreVC {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        // Register cells using a clean, reusable method
        tableView.register(cellType: DailyChallangeXIB.self)
        tableView.register(cellType: ExploreTableXIB.self)
        tableView.register(cellType: RecentActivityTableXIB.self)
    }
}

// MARK: - UITableViewDataSource
extension ExploreVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 4 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell: DailyChallangeXIB = tableView.dequeueReusableCell(for: indexPath)
            return cell
            
        case 1:
            let cell: ExploreTableXIB = tableView.dequeueReusableCell(for: indexPath)
            let apiData = ["Events & Meetups", "Training Tips", "Health Tips", "Breed Analyzer"]
            cell.configure(with: [], tableView: tableView, isHome: false)
            return cell
            
        case 2, 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentActivityTableXIB",for: indexPath) as? RecentActivityTableXIB else {
                return UITableViewCell()
            }
            let apiData = ["Mood Check", "Talk to me", "GPS Tracker", "Find a Vet"]
            cell.configureCustom(with: apiData, xibType: indexPath.section == 2 ? .trending : .nearYou)
            
            // Prevent retain cycle by capturing self weakly
            cell.onHeightChange = { [weak self] in
                guard let self else { return }
                UIView.performWithoutAnimation {
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension ExploreVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
