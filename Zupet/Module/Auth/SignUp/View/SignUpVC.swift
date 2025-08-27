//
//  SignUpVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 22/07/25.
//

import UIKit

/// ViewController responsible for user sign-up flow.
class SignUpVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgCountryFlag: UIImageView!
    @IBOutlet weak var lblTerms: UILabel!
    /// Full name input field
    @IBOutlet weak var txtFullName: UITextField!
    
    /// Email input field
    @IBOutlet weak var txtEmail: UITextField!
    
    /// Phone number input field
    @IBOutlet weak var txtPhone: UITextField!
    
    /// Terms and conditions button
    @IBOutlet weak var btnTerms: UIButton!
    
    /// Password input field
    @IBOutlet weak var txtPassword: PasswordTextField!
    
    // MARK: - Properties
    
    /// ViewModel managing business logic for sign-up
    private var viewModel: SignUpViewModel!
    private var country : [Country]?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countrys = CountryManager.shared.getCountries()
        self.country = countrys
        self.imgCountryFlag.image = CountryManager.shared.getCurrentCountry()?.flagImage ?? UIImage()
        self.txtPhone.setPrefix("(\(CountryManager.shared.getCurrentCountry()?.phoneCode ?? "")) ")
        
        // Initialize the ViewModel. Ensure it does not strongly capture `self`.
        viewModel = SignUpViewModel(view: self)
        txtPhone.delegate = self
        setupHighlightsAsync()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Apply diagonal gradient to btnContinue button and background view
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    private func setupHighlightsAsync() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.lblTerms.addTappableHighlight(substring: "Terms and Conditions", color: .ThemeOrangeEnd, font: .manropeMedium(12)) {
                    Log.debug("Terms tapped!")
                }
            }
        }
    }
    
    // MARK: - Button Actions
    
    /// Handles Terms button press
    @IBAction func termsOnPress(_ sender: UIButton) {
        // TODO: Navigate to terms and conditions screen
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func countryPickerOnPress(_ sender: UIButton) {
        
        presentBottomSheet(items: country ?? [], title: "Country") { [weak self] country in
            self?.imgCountryFlag.image = country.flagImage ?? UIImage()
            self?.txtPhone.setPrefix("(\(country.phoneCode ?? "")) ")
        }
    }
    /// Handles Sign In button press
    @IBAction func signinOnPress(_ sender: UIButton) {
        popView()
    }
    
    /// Handles Sign Up button press
    @IBAction func signupOnPress(_ sender: UIButton) {
        Task {
            // Validate fields before proceeding
            if await isValid() {
                viewModel.callSignupApi()
            }
        }
    }
    
    // MARK: - Validation
    
    /// Validates all the input fields asynchronously
    /// - Returns: A Boolean indicating whether the inputs are valid
    private func isValid() async -> Bool {
        if txtFullName.trim().isEmpty {
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
        
        if txtPassword.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.passwordRequired.rawValue)
            return false
        }
        
        if !Validator.isValidPassword(txtPassword.text ?? "") {
            await ToastManager.shared.showToast(message: ErrorMessages.invalidPassword.rawValue)
            return false
        }
        
        if !btnTerms.isSelected{
            await ToastManager.shared.showToast(message: ErrorMessages.TermsAndCondition.rawValue)
            return false
        }
        
        return true
    }
}

extension SignUpVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPhone{
            // Allow only digits
            let allowedCharacterSet = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            guard allowedCharacterSet.isSuperset(of: characterSet) else {
                return false
            }
            
            // Get updated text
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // Limit to 10 characters
            return updatedText.count <= 10
        }
        return true
    }
}
