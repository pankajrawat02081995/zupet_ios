//
//  RecentActivityTableXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 10/08/25.
//

import UIKit

enum XIBType {
    case recentActivity
    case trending
    case nearYou
}

final class RecentActivityTableXIB: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var imgClock: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var tabelViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private var items: [RecentActivity] = []
    private var xibType: XIBType = .recentActivity
    
    /// Callback to notify parent when height changes
    var onHeightChange: (() -> Void)?
    private var dummyData : [String] = []
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        items.removeAll()
        xibType = .recentActivity
        lblTitle.text = nil
        imgClock.image = nil
        tabelViewHeight.constant = 0
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.register(cellType: ActivityTableXIB.self)
        tableView.register(cellType: TrendingTopicsXIB.self)
        tableView.register(cellType: NearYouXIB.self)
    }
    
    // MARK: - Configuration
    func configure(with activities: [RecentActivity], xibType: XIBType = .recentActivity) {
        self.items = activities
        self.xibType = xibType
        
        switch xibType {
        case .trending:
            lblTitle.text = "Trending Topics"
            imgClock.image = UIImage(named: "ic_trend")
            tableView.estimatedRowHeight = 104
            
        case .nearYou:
            lblTitle.text = "Near You"
            imgClock.image = UIImage(named: "ic_near_you")
            tableView.estimatedRowHeight = 76
            
        case .recentActivity:
            lblTitle.text = "Recent Activity"
            imgClock.image = UIImage(named: "ic_clock")
            tableView.estimatedRowHeight = 44
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
        tableView.layoutIfNeeded()
        
        updateTableHeight()
    }
    
    func configureCustom(with activities: [String], xibType: XIBType = .recentActivity) {
        self.dummyData = activities
        self.xibType = xibType
        
        switch xibType {
        case .trending:
            lblTitle.text = "Trending Topics"
            imgClock.image = UIImage(named: "ic_trend")
            tableView.estimatedRowHeight = 104
            
        case .nearYou:
            lblTitle.text = "Near You"
            imgClock.image = UIImage(named: "ic_near_you")
            tableView.estimatedRowHeight = 76
            
        case .recentActivity:
            lblTitle.text = "Recent Activity"
            imgClock.image = UIImage(named: "ic_clock")
            tableView.estimatedRowHeight = 44
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
        tableView.layoutIfNeeded()
        
        updateTableHeight()
    }
    
    // MARK: - Layout Updates
    private func updateTableHeight() {
        let height = tableView.contentSize.height
        
        if tabelViewHeight.constant != height {
            tabelViewHeight.constant = height
            UIView.performWithoutAnimation { [weak self] in
                self?.onHeightChange?()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension RecentActivityTableXIB: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xibType == .recentActivity ? items.count : dummyData.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch xibType {
        case .trending:
            let cell: TrendingTopicsXIB = tableView.dequeueReusableCell(for: indexPath)
            return cell
            
        case .nearYou:
            let cell: NearYouXIB = tableView.dequeueReusableCell(for: indexPath)
            return cell
            
        case .recentActivity:
            let cell: ActivityTableXIB = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
}
