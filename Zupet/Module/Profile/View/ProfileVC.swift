//
//  ProfileVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 24/08/25.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeBold(18)
        }
    }
    @IBOutlet weak var lblEmail: UILabel!{
        didSet{
            lblEmail.font = .manropeRegular(14)
        }
    }
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            lblName.font = .manropeBold(24)
        }
    }
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: PetCollectionXIB.self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Apply diagonal gradient to btnContinue button and background view
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }

    @IBAction func settingOnPress(_ sender: UIButton) {
        push(AppointmentDetailsVC.self, from: .profile)
    }
    
}

extension ProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PetCollectionXIB = collectionView.dequeueReusableCell(for: indexPath)
        if indexPath.item == 0{
            cell.addView.isHidden = false
            cell.petView.isHidden = true
        }else{
            cell.addView.isHidden = true
            cell.petView.isHidden = false
        }
        return cell
    }
    
    // 🔹 Cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width / 3   // half width
        let height = collectionView.bounds.height     // full height of collection view
        return CGSize(width: width, height: height)
    }
    
    // (optional) spacing between cells
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
