//
//  SignInVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 22/07/25.
//

import UIKit

/// ViewController for handling Sign In screen logic and UI
final class SignInVC: UIViewController {
    
    // MARK: - Outlets
    
    /// The top container view that has rounded top corners
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 20
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    
    /// Text field for entering email
    @IBOutlet weak var txtEmail: UITextField!
    
    /// Text field for entering password
    @IBOutlet weak var txtPassword: UITextField!
    
    /// "Remember me" checkbox button
    @IBOutlet weak var btnRemember: UIButton!
    
    /// Google Sign-In button
    @IBOutlet weak var btnGoogle: UIButton!
    
    /// Sign-In button with gradient background
    @IBOutlet weak var btnSignIn: UIButton!
    
    /// Background view with gradient
    @IBOutlet weak var bgView: UIView!
    
    private var viewModel: SignInViewModel!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup if needed
        viewModel = SignInViewModel(view: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Apply diagonal gradient to Sign-In button and background view
        btnSignIn.applyDiagonalGradient()
        btnSignIn.updateGradientFrameIfNeeded()
        
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    // MARK: - Actions
    
    /// Handles "Forgot Password" button press
    @IBAction func forgotPasswordOnPress(_ sender: UIButton) {
        // Navigate to Forgot Password screen
    }
    
    /// Toggles "Remember me" state
    @IBAction func rememberMeOnPress(_ sender: UIButton) {
        sender.isSelected.toggle()
        // Save to user defaults or in-memory state
    }
    
    /// Handles sign in process when button is pressed
    @IBAction func signOnPress(_ sender: UIButton) {
        Task {
            // Validate fields before proceeding
            if await isValid() {
                viewModel.callSignInApi()
            }
        }
    }
    
    /// Handles Google Sign-In process
    @IBAction func googleOnPress(_ sender: UIButton) {
        // Trigger Google Sign-In flow
        Task {
            do {
                let user = try await GoogleSignInManager.shared.signIn(from: self)
                Log.debug("Google User: \(user.name), \(user.email)")
                viewModel.socialLogin()
            } catch {
                Log.debug("Google Sign-In failed: \(error.localizedDescription)")
            }
        }
    }
    
    /// Navigates to the Sign-Up screen
    @IBAction func signupOnPress(_ sender: UIButton) {
        // Push or present Sign-Up screen
        push(SignUpVC.self, from: .main)
    }
    
    // MARK: - Deinitialization
    
    /// Clean-up to ensure no memory leaks
    deinit {
        Log.debug("SignInVC deinitialized")
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
}
