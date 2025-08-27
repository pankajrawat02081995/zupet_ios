//
//  LanguageVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 27/08/25.
//

import UIKit

class LanguageVC: UIViewController {

    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbltitle: UILabel!{
        didSet{
            lbltitle.font = .manropeBold(18)
            lbltitle.localize("Language")
        }
    }
    
    private var selectedIndex : Int?
    private var viewModel : LanguageViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LanguageViewModel(view: self)
        setupTableView()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(cellType: LanguageXIB.self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Apply diagonal gradient to btnContinue button and background view
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        popView()
    }
    
    @IBAction func saveOnPress(_ sender: UIButton) {
    }
}

extension LanguageVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.languages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : LanguageXIB = tableView.dequeueReusableCell(for: indexPath)
        cell.lblLanguage.text = viewModel?.languages[indexPath.row].language ?? ""
        if selectedIndex == indexPath.row{
            cell.lblLanguage.textColor = .textBlack
            cell.imgCheck.image = .icCheckCircle
        }else{
            cell.lblLanguage.textColor = .appDarkGray
            cell.imgCheck.image = .icUncheckCircle
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}
