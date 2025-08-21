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

    @IBOutlet weak var txtHeightInch: UITextField!

    @IBOutlet weak var txtAge: UITextField!
    
    @IBOutlet weak var txtBreed: UITextField!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var txtWeight: UITextField!
    
    @IBOutlet weak var txtColor: UITextField!
    @IBOutlet weak var txtSpecies: UITextField!
    
    @IBOutlet weak var lblBreed: UILabel!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    private var viewModel : PetDetailsViewModel!
    
    private var dropDown : DropdownView?
    
    private let heightFeetOptions: [String] = ["0 ft", "1 ft", "2 ft", "3 ft", "4 ft", "5 ft", "6 ft", "7 ft"]
    private let heightInchOptions: [String] = ["0 inch", "1 inch", "2 inch", "3 inch", "4 inch", "5 inch", "6 inch", "7 inch", "8 inch", "9 inch", "10 inch", "11 inch"]

    private var breedOptions: [String]?
    private var colorOptions: [String]?
    var petSpecies: String?
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.text = "Tell us about \nyour \(petSpecies ?? "")"
        }
    }
    func loadBreedOptions() async {
        breedOptions =  petSpecies == "dog" ? await UserDefaultsManager.shared.get(BreedData.self, forKey: UserDefaultsKey.BreedData)?.dogBreeds ?? [] : await UserDefaultsManager.shared.get(BreedData.self, forKey: UserDefaultsKey.BreedData)?.catBreeds ?? []
        colorOptions =  petSpecies == "dog" ? await UserDefaultsManager.shared.get(BreedData.self, forKey: UserDefaultsKey.BreedData)?.dogColors ?? [] : await UserDefaultsManager.shared.get(BreedData.self, forKey: UserDefaultsKey.BreedData)?.catColors ?? []

    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDown = DropdownView()

        // Preload breed options in background without blocking UI
        Task { [weak self] in
            await self?.loadBreedOptions()
        }
        
        viewModel = PetDetailsViewModel(view: self)
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
        txtBreed.delegate = self
        
        // Add real-time change listeners
        txtPetName.addTarget(self, action: #selector(petNameChanged), for: .editingChanged)
//        txtSpecies.addTarget(self, action: #selector(speciesInfoChanged), for: .editingDidBegin)
        txtAge.addTarget(self, action: #selector(ageInfoChanged), for: .editingDidBegin)
        txtHeight.addTarget(self, action: #selector(heightInfoChanged), for: .editingDidBegin)
        txtBreed.addTarget(self, action: #selector(breedInfoChanged), for: .editingDidBegin)
        txtColor.addTarget(self, action: #selector(colorInfoChanged), for: .editingDidBegin)
        txtHeightInch.addTarget(self, action: #selector(heightInchInfoChanged), for: .editingDidBegin)
        txtWeight.addTarget(self, action: #selector(weightInfoChanged), for: .editingChanged)
    }
    
    // MARK: - UITextField Events (Memory-safe, no retain cycles)
    
    /// Updates pet name label live
    @objc private func petNameChanged() {
        lblPetName.text = txtPetName.text
    }
    
    @objc private func speciesInfoChanged() {
        self.txtSpecies.resignFirstResponder()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.dropDown?.show(from: self.txtSpecies, data: ["Dog", "Cat"]) { [weak self] selection in
                guard let self else { return }
                Log.debug(selection)
                self.txtSpecies.text = selection
                self.txtBreed.text = ""
                self.lblBreed.text = "\(selection) . \(self.txtAge.text ?? "")"
            }
        }
    }
    
    /// Combines species and age into breed label
    @objc private func ageInfoChanged() {
        self.txtAge.resignFirstResponder()
        dropDown?.show(from: self.txtAge, data: ["1","2","3","4","5","6","7","8","9","10","11","12"], onSelect: {[weak self] (index) in
            guard let self = self else { return }
            Log.debug(index)
            let species = self.txtBreed.text ?? ""
            self.txtAge.text = index
            self.lblBreed.text = "\(species) . \(index) yrs"
        })
    }
    
    /// Combines species and age into breed label
    @objc private func breedInfoChanged() {
        self.txtBreed.resignFirstResponder()
        if breedOptions?.isEmpty == true {return}
        dropDown?.show(from: self.txtBreed, data: breedOptions ?? [], onSelect: {[weak self] (index) in
            guard let self = self else { return }
            Log.debug(index)
            self.txtBreed.text = index
            self.lblBreed.text = "\(index) . \(self.txtAge.text ?? "")"

        })
    }
    
    @objc private func colorInfoChanged() {
        self.txtColor.resignFirstResponder()
        if colorOptions?.isEmpty == true {return}
        dropDown?.show(from: self.txtColor, data: colorOptions ?? [], onSelect: {[weak self] (index) in
            guard let self = self else { return }
            Log.debug(index)
            self.txtColor.text = index
        })
    }
    
    @objc private func heightInfoChanged() {
        self.txtHeight.resignFirstResponder()
        dropDown?.show(from: self.txtHeight, data: self.heightFeetOptions, onSelect: {[weak self] (index) in
            guard let self = self else { return }
            Log.debug(index)
            let weight = self.txtWeight.text ?? ""
            let inch = self.txtHeightInch.text ?? ""
            self.txtHeight.text = index
            self.lblWeight.text = "\(index) \(inch) . \(weight)"
        })
    }
    
    @objc private func heightInchInfoChanged() {
        self.txtHeightInch.resignFirstResponder()
        dropDown?.show(from: self.txtHeightInch, data: self.heightInchOptions, onSelect: {[weak self] (index) in
            guard let self = self else { return }
            Log.debug(index)
            let weight = self.txtWeight.text ?? ""
            let feet = self.txtHeight.text ?? ""
            self.txtHeightInch.text = index
            self.lblWeight.text = "\(feet) \(index) . \(weight)"
        })
    }
    
    /// Combines height and weight into weight label
    @objc private func weightInfoChanged() {
        let height = txtHeight.text ?? ""
        let inch = self.txtHeightInch.text ?? ""
        let weight = txtWeight.text ?? ""
        lblWeight.text = "\(height) \(inch) . \(weight) kg"
    }
    
    // MARK: - Continue Action
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        Task{
            if await isValid(){
                viewModel.createPet()
            }
        }
    }
    
    // MARK: - Deinit for Debugging
    
    deinit {
        // Not required for UITextField cleanup,
        // but useful for confirming deallocation
        Log.debug("PetDetailVC deinitialized")
    }
    
    private func isValid() async -> Bool {
        
        if txtPetName.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.petName.rawValue)
            return false
        }
        
        if txtBreed.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.petBreed.rawValue)
            return false
        }
        
        if txtColor.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.petColor.rawValue)
            return false
        }
        
        if txtAge.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.petAge.rawValue)
            return false
        }
        
        if txtHeight.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.petHeightft.rawValue)
            return false
        }
        
        if txtHeightInch.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.petHeightinch.rawValue)
            return false
        }
        
        if txtWeight.trim().isEmpty {
            await ToastManager.shared.showToast(message: ErrorMessages.petWeight.rawValue)
            return false
        }
        
        return true
    }
}

// MARK: - UITextFieldDelegate (no retained memory)

extension PetDetailVC: UITextFieldDelegate {
    // Add if needed, e.g., dismiss keyboard on return
}
