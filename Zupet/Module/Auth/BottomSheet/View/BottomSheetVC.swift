//
//  BottomSheetVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 22/08/25.
//

import UIKit

enum BottomSheetType{
    case Country
    case Globle
}

final class BottomSheetVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var conatinerView: UIView!{
        didSet{
            conatinerView.layer.cornerRadius = 16
            conatinerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            conatinerView.clipsToBounds = true
        }
    }
   
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var allItems: [String] = []
    private var filteredItems: [String] = []
    private var headerLabel : String = ""
    
    // Inside BottomSheetVC
    var allCountries: [Country] = []
    var filteredCountries: [Country] = []
    var onCountrySelected: ((Country) -> Void)?
    
    // Callback when item selected
    var onItemSelected: ((String) -> Void)?
    var bottomSheetType : BottomSheetType?
    
    // Background dimming view
    private let dimmedView = UIView()
    
    // MARK: - Init with items
    static func create(items: [String], title: String = "Select an Option", bottomSheetType : BottomSheetType,onSelect: @escaping (String) -> Void) -> BottomSheetVC {
        let vc = BottomSheetVC.instantiate(from: .main)
        vc.allItems = items
        vc.bottomSheetType = bottomSheetType
        vc.headerLabel = title
        vc.filteredItems = items
        vc.onItemSelected = onSelect
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
    
    // MARK: - Init with Countries
    static func create(countries: [Country],
                       title: String = "Select Country",bottomSheetType : BottomSheetType,
                       onSelect: @escaping (Country) -> Void) -> BottomSheetVC {
        let vc = BottomSheetVC.instantiate(from: .main)
        vc.allCountries = countries
        vc.bottomSheetType = bottomSheetType
        vc.filteredCountries = countries
        vc.headerLabel = title
        vc.onCountrySelected = onSelect
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDimmedBackground()
        setupTableView()
        setupSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateShowSheet()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animateHideSheet()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func setupSearch() {
        txtSearch.becomeFirstResponder()
        txtSearch.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
    }
    
    private func setupDimmedBackground() {
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        view.insertSubview(dimmedView, at: 0)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Animations
    private func animateShowSheet() {
        // Start offscreen (below)
        let screenHeight = view.bounds.height
        conatinerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseOut]) {
            self.dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.conatinerView.transform = .identity
        }
    }
    
    private func animateHideSheet() {
        let screenHeight = view.bounds.height
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [.curveEaseIn]) {
            self.dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.conatinerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        }
    }
    
    // MARK: - Actions
    @objc private func handleBackgroundTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
        let text = sender.text?.lowercased() ?? ""
        
        if bottomSheetType == .Globle {
            // allItems is [String]
            filteredItems = text.isEmpty
                ? allItems
                : allItems.filter { $0.lowercased().contains(text) }
        } else {
            // allCountries is [Country]
            filteredCountries = text.isEmpty
                ? allCountries
                : allCountries.filter {
                    ($0.name?.lowercased().contains(text) ?? false) ||
                    ($0.code?.lowercased().contains(text) ?? false) ||
                    ($0.phoneCode?.lowercased().contains(text) ?? false)
                }
        }
        
        tableView.reloadData()
    }

}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension BottomSheetVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bottomSheetType == .Globle ? filteredItems.count : filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if bottomSheetType == .Globle{
            cell.textLabel?.text = filteredItems[indexPath.row]
        }else{
            cell.textLabel?.text = "\(filteredCountries[indexPath.row].flag ?? "") \(filteredCountries[indexPath.row].name ?? "") \(filteredCountries[indexPath.row].phoneCode ?? "")"
        }
        cell.textLabel?.font = .manropeMedium(16)
        cell.textLabel?.textColor = .textBlack
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true) { [weak self] in
            if self?.bottomSheetType == .Globle{
                let selected = self?.filteredItems[indexPath.row]
                self?.onItemSelected?(selected ?? "")
            }else{
                if let selected = self?.filteredCountries[indexPath.row]{
                    self?.onCountrySelected?(selected)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.text = self.headerLabel
        headerLabel.font = .manropeBold(28) // 👈 custom font
        headerLabel.textColor = .textBlack
        headerLabel.textAlignment = .left
        headerLabel.backgroundColor = .clear
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        container.backgroundColor = .white
        container.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            headerLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            headerLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4)
        ])

        return container
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

}
