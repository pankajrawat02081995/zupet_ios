//
//  PetNoseScanerVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 01/08/25.
//

import UIKit

class PetNoseScanerVC: UIViewController {
    
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var imgPet: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var btnFlip: UIButton!
    var petSpecies : String?
    var isBackVisible : Bool = false
    
    private var viewModel : PetNoseScanerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PetNoseScanerViewModel(view: self)
        btnBack.isHidden = !isBackVisible
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraView.start()  // ask permission + start
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraView.stop()   // release memory
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Apply diagonal gradient to btnContinue button and background view
        btnContinue.applyDiagonalGradient()
        btnContinue.updateGradientFrameIfNeeded()
        
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    @IBAction func continewOnPress(_ sender: UIButton) {
        if imgPet.image?.toBase64()?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            Task{
                await ToastManager.shared.showToast(message: ErrorMessages.CaptureImage.rawValue)
            }
        }else{
            viewModel?.scanNose(img: imgPet.image?.toBase64() ?? "")
        }
    }
    
    // MARK: - Button Actions
    @IBAction func captureTapped(_ sender: UIButton) {
        cameraView.capturePhoto { [weak self] image in
            guard let self = self else{return}
            cameraView.stop()
            btnCapture.isHidden = true
            imgPet.isHidden = false
            imgPet.image = image
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        popView()
    }
    
    @IBAction func flashOnPress(_ sender: UIButton) {
        cameraView.toggleFlash()
    }
    
    @IBAction func refreshOnPress(_ sender: UIButton) {
        if imgPet.isHidden == true{
            return
        }
        btnCapture.isHidden = false
        imgPet.isHidden = true
        cameraView.refresh()
    }
    
    @IBAction func flipOnPress(_ sender: UIButton) {
        cameraView.flipCamera()
    }
    
}
