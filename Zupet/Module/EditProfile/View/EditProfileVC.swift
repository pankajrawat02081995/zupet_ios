//
//  EditProfileVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 26/08/25.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeBold(18)
            lblTitle.localize("Edit Profile")
        }
    }
    
    private var viewModel : EditProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = EditProfileViewModel(view: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Apply diagonal gradient to btnContinue button and background view
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task{
            let user = await UserDefaultsManager.shared.fatchCurentUser()
            txtName.text = user?.fullName ?? ""
            txtEmail.text = user?.email ?? ""
            imgUser.setImage(from: user?.avatar ?? "")
            txtPhone.text = user?.phone ?? ""
            txtPhone.setPrefix("(\(user?.countryCode ?? "")) ")
            imgFlag.image = CountryManager.shared.getCountry(phoneCode: user?.countryCode ?? "")?.flagImage ?? UIImage()
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        popView()
    }
    
    @IBAction func flagOnPress(_ sender: UIButton) {
        presentBottomSheet(items: CountryManager.shared.getCountries(), title: "Country") { [weak self] country in
            self?.imgFlag.image = country.flagImage ?? UIImage()
            self?.txtPhone.setPrefix("(\(country.phoneCode ?? "")) ")
        }
    }
    
    @IBAction func saveOnPress(_ sender: UIButton) {
        Task {
            // Validate fields before proceeding
            if await isValid() {
                viewModel?.callEditProfileAPI()
            }
        }
        }
    
    private func isValid() async -> Bool {
        if txtName.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.fullName.rawValue)
            return false
        }
        
        if txtEmail.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.emailRequired.rawValue)
            return false
        }
        
        if !Validator.isValidEmail(txtEmail.text ?? "") {
            await ToastManager.shared.showToast(message: ErrorMessages.invalidEmail.rawValue)
            return false
        }
        
        if txtPhone.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.phone.rawValue)
            return false
        }
        
        if !Validator.isValidPhone(txtPhone.text ?? "") {
            await ToastManager.shared.showToast(message: ErrorMessages.invalidPhone.rawValue)
            return false
        }
        return true
    }
}
