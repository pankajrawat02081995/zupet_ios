//
//  MoodDetectionVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 11/08/25.
//

import UIKit

final class MoodDetectionVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var lblTitle: UILabel! {
        didSet {
            lblTitle.font = .manropeBold(18)
        }
    }
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.register(cellType: MoodDetectionCameraXIB.self)
        tableView.register(cellType: RecentActivityTableXIB.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView() // Remove empty separators
        tableView.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Actions
    @IBAction private func backOnPress(_ sender: UIButton) {
        popView()
    }
}

// MARK: - UITableViewDataSource
extension MoodDetectionVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell : MoodDetectionCameraXIB = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }else{
            let cell : RecentActivityTableXIB = tableView.dequeueReusableCell(for: indexPath)
            let apiData = ["Mood Check", "Talk to me", "GPS Tracker", "Find a Vet"]
            cell.configureCustom(with: apiData)
            cell.onHeightChange = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MoodDetectionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
