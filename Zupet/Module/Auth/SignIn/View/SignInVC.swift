//
//  SignInVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 22/07/25.
//

import UIKit

/// ViewController for handling Sign In screen logic and UI
final class SignInVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 20
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: PasswordTextField!
    @IBOutlet weak var btnRemember: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    private var viewModel: SignInViewModel!
    private var didSetupGradients = false
    private var credentialsManager : CredentialsManager?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        credentialsManager = CredentialsManager()
        
        // Add tap gesture
        if credentialsManager?.checkRememberMe() == true{
            credentialsManager?.load { [weak self] email, password, rememberMe in
                self?.txtEmail.text = email
                self?.txtPassword.text = password
                self?.btnRemember.isSelected = rememberMe
            }
        } else {
            self.btnRemember.isSelected = false
        }
        
        #if DEBUG
                txtEmail.text = "p@yopmail.com"
                txtPassword.text = "Qwerty@1234"
        #endif
        viewModel = SignInViewModel(view: self) // Make view weak in ViewModel
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !didSetupGradients else { return }
        btnSignIn.applyDiagonalGradient()
        btnSignIn.updateGradientFrameIfNeeded()
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
        didSetupGradients = true
    }
    
    @IBAction func forgotPasswordOnPress(_ sender: UIButton) {
        push(ForgotPasswordVC.self, from: .main)
    }
    
    @IBAction func rememberMeOnPress(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func signOnPress(_ sender: UIButton) {
        Task { [weak self] in
            guard let self else { return }
            if await self.isValid() {
                if btnRemember.isSelected {
                    self.credentialsManager?.save(email: txtEmail.text ?? "", password: txtPassword.text ?? "", rememberMe: true)
                } else {
                    self.credentialsManager?.clear()
                }
                self.viewModel.callSignInApi()
            }
        }
    }
    
    @IBAction func googleOnPress(_ sender: UIButton) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let user = try await GoogleSignInManager.shared.signIn(from: self)
                self.viewModel.socialLogin(token: user.idToken, type: .Google)
            } catch {
                Log.debug("Google Sign-In failed: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func signupOnPress(_ sender: UIButton) {
        push(SignUpVC.self, from: .main)
    }
    
    private func isValid() async -> Bool {
        if txtEmail.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.emailRequired.rawValue)
            return false
        }
        if !Validator.isValidEmail(txtEmail.text ?? "") {
            await ToastManager.shared.showToast(message: ErrorMessages.invalidEmail.rawValue)
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
        return true
    }
    
    deinit {
        Log.debug("SignInVC deinitialized")
    }
}
