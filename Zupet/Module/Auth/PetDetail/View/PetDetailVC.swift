//
//  PetDetailVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 01/08/25.
//

import UIKit

class PetDetailVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblPetName: UILabel!
    @IBOutlet weak var txtPetName: UITextField!
    
    @IBOutlet weak var txtHeight: UITextField!
    
    @IBOutlet weak var txtAge: UITextField!
    
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var txtWeight: UITextField!
    
    @IBOutlet weak var txtSpecies: UITextField!
    
    @IBOutlet weak var lblBreed: UILabel!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Apply diagonal gradient to btnContinue button and background view
        btnContinue.applyDiagonalGradient()
        btnContinue.updateGradientFrameIfNeeded()

        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    // MARK: - TextField Setup
    
    private func setupTextFields() {
        // Delegates not retained (safe memory-wise)
        txtPetName.delegate = self
        txtSpecies.delegate = self
        txtAge.delegate = self
        txtHeight.delegate = self
        txtWeight.delegate = self
        
        // Add real-time change listeners
        txtPetName.addTarget(self, action: #selector(petNameChanged), for: .editingChanged)
        txtSpecies.addTarget(self, action: #selector(breedInfoChanged), for: .editingChanged)
        txtAge.addTarget(self, action: #selector(breedInfoChanged), for: .editingChanged)
        txtHeight.addTarget(self, action: #selector(weightInfoChanged), for: .editingChanged)
        txtWeight.addTarget(self, action: #selector(weightInfoChanged), for: .editingChanged)
    }
    
    // MARK: - UITextField Events (Memory-safe, no retain cycles)
    
    /// Updates pet name label live
    @objc private func petNameChanged() {
        lblPetName.text = txtPetName.text
    }
    
    /// Combines species and age into breed label
    @objc private func breedInfoChanged() {
        let species = txtSpecies.text ?? ""
        let age = txtAge.text ?? ""
        lblBreed.text = "\(species) . \(age)"
    }
    
    /// Combines height and weight into weight label
    @objc private func weightInfoChanged() {
        let height = txtHeight.text ?? ""
        let weight = txtWeight.text ?? ""
        lblWeight.text = "\(height) . \(weight)"
    }
    
    // MARK: - Continue Action
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        // Safe: no closures, no retained references
        // Proceed with validation or navigation
    }
    
    // MARK: - Deinit for Debugging
    
    deinit {
        // Not required for UITextField cleanup,
        // but useful for confirming deallocation
        print("PetDetailVC deinitialized")
    }
}

// MARK: - UITextFieldDelegate (no retained memory)

extension PetDetailVC: UITextFieldDelegate {
    // Add if needed, e.g., dismiss keyboard on return
}
