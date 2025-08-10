//
//  RecentActivityTableXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 10/08/25.
//

import UIKit

class RecentActivityTableXIB: UITableViewCell {

    @IBOutlet weak var tabelViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!

    private var items: [String] = []
    var onHeightChange: (() -> Void)? // Notify parent when height changes

    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        let nib = UINib(nibName: "ActivityTableXIB", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ActivityTableXIB")
    }

    func configure(with activities: [String]) {
        self.items = activities
        tableView.reloadData()
        tableView.layoutIfNeeded()
        updateTableHeight()
    }

    private func updateTableHeight() {
        let height = tableView.contentSize.height
        if tabelViewHeight.constant != height {
            tabelViewHeight.constant = height
            onHeightChange?() // Tell parent to update its layout
        }
    }
}

extension RecentActivityTableXIB: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableXIB", for: indexPath) as? ActivityTableXIB else {
            return UITableViewCell()
        }
        // Example:
        // cell.lblTitle.text = items[indexPath.row]
        return cell
    }
}
