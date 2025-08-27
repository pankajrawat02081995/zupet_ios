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
    @IBOutlet weak var containerView: UIView! {
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
    
    private var viewModel: PetDetailsViewModel?
    
    private let heightFeetOptions: [String] = ["0 ft", "1 ft", "2 ft", "3 ft", "4 ft", "5 ft", "6 ft", "7 ft"]
    private let heightInchOptions: [String] = ["0 inch", "1 inch", "2 inch", "3 inch", "4 inch", "5 inch", "6 inch", "7 inch", "8 inch", "9 inch", "10 inch", "11 inch"]

    private var breedOptions: [String]?
    private var colorOptions: [String]?
    var petSpecies: String?
    var ageDate: Date? = nil
    
    @IBOutlet weak var lblTitle: UILabel! {
        didSet {
            lblTitle.text = "Tell us about \nyour \(petSpecies ?? "")"
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - Data Load
    
    func loadBreedOptions() async {
        let breedData = await UserDefaultsManager.shared.get(BreedData.self, forKey: UserDefaultsKey.BreedData)
        breedOptions = petSpecies == "dog" ? breedData?.dogBreeds ?? [] : breedData?.catBreeds ?? []
        colorOptions = petSpecies == "dog" ? breedData?.dogColors ?? [] : breedData?.catColors ?? []
    }
    
    // MARK: - TextField Setup
    
    private func setupTextFields() {
        [txtPetName,txtColor, txtAge, txtHeight,txtHeightInch, txtBreed].forEach { $0?.delegate = self }
        
        txtPetName.addTarget(self, action: #selector(petNameChanged), for: .editingChanged)
//        txtAge.addTarget(self, action: #selector(ageInfoChanged), for: .editingDidBegin)
//        txtHeight.addTarget(self, action: #selector(heightInfoChanged), for: .editingDidBegin)
//        txtBreed.addTarget(self, action: #selector(breedInfoChanged), for: .editingDidBegin)
//        txtColor.addTarget(self, action: #selector(colorInfoChanged), for: .editingDidBegin)
//        txtHeightInch.addTarget(self, action: #selector(heightInchInfoChanged), for: .editingDidBegin)
//        txtWeight.addTarget(self, action: #selector(weightInfoChanged), for: .editingChanged)
    }
    
    // MARK: - UITextField Events
    
    @objc private func petNameChanged() {
        lblPetName.text = txtPetName.text
    }
    
    private func getAge(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        return ageComponents.year ?? 0
    }
    
    @objc private func breedInfoChanged() {
        txtBreed.resignFirstResponder()
        presentBottomSheet(items: breedOptions ?? [], title: "Breed") { [weak self] selected in
            self?.txtBreed.text = selected
            self?.updateBreedLabel()
        }
    }
    
    @objc private func colorInfoChanged() {
        txtColor.resignFirstResponder()
        presentBottomSheet(items: colorOptions ?? [], title: "Color") { [weak self] selected in
            self?.txtColor.text = selected
        }
    }
    
    @objc private func heightInfoChanged() {
        txtHeight.resignFirstResponder()
        presentBottomSheet(items: heightFeetOptions, title: "Height(feet)") { [weak self] selected in
            self?.txtHeight.text = selected
            self?.updateWeightLabel()
        }
    }
    
    @objc private func heightInchInfoChanged() {
        txtHeightInch.resignFirstResponder()
        presentBottomSheet(items: heightInchOptions, title: "Height(inches)") { [weak self] selected in
            self?.txtHeightInch.text = selected
            self?.updateWeightLabel()
        }
    }
    
    @objc private func weightInfoChanged() {
        updateWeightLabel()
    }
    
    // MARK: - Label Updaters
    
    private func updateBreedLabel() {
        let breed = txtBreed.text ?? ""
        let age = "\(getAge(from: self.ageDate ?? Date()))"
        lblBreed.text = breed.isEmpty ? "\(age) yrs" : "\(breed)\(age.isEmpty ? "" : " . \(age) yrs")"
    }
    
    private func updateWeightLabel() {
        let feet = txtHeight.text ?? ""
        let inch = txtHeightInch.text ?? ""
        let weight = txtWeight.text ?? ""
        lblWeight.text = "\(feet) \(inch)\(weight.isEmpty ? "" : " . \(weight) kg")"
    }
    
    // MARK: - Bottom Sheet Helper
    
    private func presentBottomSheet(items: [String], title: String, onSelect: @escaping (String) -> Void) {
        let bottomSheet = BottomSheetVC.create(items: items,title: title, bottomSheetType: .Globle, onSelect: onSelect)
        bottomSheet.modalPresentationStyle = .overCurrentContext
        present(bottomSheet, animated: true)
    }
    
    // MARK: - Continue Action
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        Task {
            if await isValid() {
                viewModel?.createPet()
            }
        }
    }
    
    // MARK: - Validation
    
    private func validate(field: UITextField, error: ErrorMessages) async -> Bool {
        guard !field.trim().isEmpty else {
            await ToastManager.shared.showToast(message: error.rawValue)
            return false
        }
        return true
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
    
    // MARK: - Keyboard Dismiss
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Deinit
    
    deinit {
        Log.debug("PetDetailVC deinitialized")
    }
}

// MARK: - UITextFieldDelegate

extension PetDetailVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtAge{
            DatePickerManager.shared.showDatePicker(from: textField,maximumDate:Date()) { [weak self] dateString, date in
                guard let self else { return }
                Log.debug("\(dateString)")
                self.txtAge.text = dateString
                self.ageDate = date
                self.updateBreedLabel()
            }
            return false
        }else if textField == txtBreed{
            self.breedInfoChanged()
            return false
        }else if textField == txtColor{
            self.colorInfoChanged()
            return false
        }else if textField == txtHeight{
            self.heightInfoChanged()
            return false
        }else if textField == txtHeightInch{
            self.heightInchInfoChanged()
            return false
        }
        return true
    }
}
