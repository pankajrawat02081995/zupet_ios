//
//  SettingVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 25/08/25.
//

import UIKit

class SettingVC: UIViewController {
    
    @IBOutlet weak var imgView: UIButton!
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeBold(18)
            lblTitle.localize("Settings")
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel : SettingViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SettingViewModel(view: self)
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task{
            let user = await UserDefaultsManager.shared.fatchCurentUser()
            imgView?.setImage(from: user?.avatar ?? "")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Apply diagonal gradient to btnContinue button and background view
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(cellType: SettingXIB.self)
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        popView()
    }
    
    
}

extension SettingVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.makeSettingsData().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.makeSettingsData()[section].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear  // or your custom color
        
        let label = UILabel()
        label.text = viewModel?.makeSettingsData()[section].title
        label.font = .manropeBold(18)
        label.textColor = .TextBlack   // custom color
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16), // left padding
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 // adjust as needed
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SettingXIB = tableView.dequeueReusableCell(for: indexPath)
        let item = viewModel?.makeSettingsData()[indexPath.section].items[indexPath.row]
        cell.lblTitle?.text = item?.title ?? ""
        cell.lblTitle?.font = .manropeRegular(16)
        cell.imgSetting?.image = item?.icon ??  UIImage()
        cell.btnSwitch.isHidden = item?.isNextIcon == true
        cell.imgNext.isHidden = item?.isNextIcon == false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel?.makeSettingsData()[indexPath.section].items[indexPath.row]
        switch item?.title{
        case "Logout".localized:
            logoutPress()
        case "Delete Account".localized:
            deletePress()
        case "Edit Profile".localized:
            push(EditProfileVC.self, from: .profile)
        case "Change Password".localized:
            push(ChangePasswordVC.self, from: .profile)
        case "Language".localized:
            push(LanguageVC.self, from: .profile)
        case .some(_):
            break
        case .none:
            break
        }
    }
    
    func logoutPress() {
        presentPopup(from: self, mainTitle: .Logout, subTitle: .Logout, btnOkTitle: .Yes, btnCancelTitle: .Cancel) {
            self.viewModel?.callLogoutApi()
        }
    }
    
    func deletePress() {
        presentPopup(from: self, mainTitle: .Delete, subTitle: .Delete, btnOkTitle: .Yes, btnCancelTitle: .Cancel) {
            self.viewModel?.callDeleteApi()
        }
    }
    
}
