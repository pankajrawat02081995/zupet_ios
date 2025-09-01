//
//  AppointmentTimelineXIB.swift
//  Zupet
//
//  Created by Pankaj Rawat on 30/08/25.
//

import UIKit

class AppointmentTimelineXIB: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblPreferdTitle: UILabel!{
        didSet{
            lblPreferdTitle.font = .manropeBold(14)
        }
    }
    @IBOutlet weak var btnDecline: UIButton!{
        didSet{
            btnDecline.addInnerShadow(cornerRadius: btnDecline.layer.cornerRadius)
        }
    }
    @IBOutlet weak var btnAccept: UIButton!{
        didSet{
            btnAccept.addInnerShadow(cornerRadius: btnAccept.layer.cornerRadius)
        }
    }
    @IBOutlet weak var collectonViewContainer: UIView!
    @IBOutlet weak var timelineView: UIView!
    @IBOutlet weak var lblSubtitle: UILabel!{
        didSet{
            lblSubtitle.font = .manropeRegular(12)
        }
    }
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeBold(14)
        }
    }
    @IBOutlet weak var btnActionStackConatiner: UIStackView!
    @IBOutlet weak var imgTimeline: UIImageView!
    
    var acceptOnPress : ((Int) -> Void)?
    var declineOnPress : ((Int) -> Void)?
    private var dates : [String]?
    private var selectedDate : [String]? = []
    var selectDate : (([String]) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func configData(dates : [String]){
        self.dates = dates
        collectionView.reloadData()
    }
    
    private func setupCollectionView(){
        // Afternoon Set Collection
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: DateXIB.self)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 12   // ✅ horizontal spacing between cells
            layout.minimumInteritemSpacing = 0 // ✅ vertical spacing (not relevant here)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func acceptOnPress(_ sender: UIButton) {
        acceptOnPress?(sender.tag)
    }
    
    @IBAction func declineOnPress(_ sender: UIButton) {
        declineOnPress?(sender.tag)
    }
    
}

// MARK: - UICollectionView Delegate & DataSource
extension AppointmentTimelineXIB: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dates?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : DateXIB = collectionView.dequeueReusableCell(for: indexPath)
        let indexData = self.dates?[indexPath.row]
        cell.lblDay.text = indexData?.toLocalTime(inputFormat: .utcFormate, outputFormat: .ddEEE)
        cell.lblDate.text = indexData?.toLocalTime(inputFormat: .utcFormate, outputFormat: .HHmm)
        
        cell.lblDate.textColor = .textBlack
        
        cell.lblDay.font = .manropeRegular(14)
        cell.lblDate.font = .manropeBold(12)
        
        if selectedDate?.contains(indexData ?? "") == true{
            cell.containerView.borderColor = .ThemeOrangeEnd
            cell.lblDay.textColor = .ThemeOrangeEnd
        }else{
            cell.containerView.borderColor = .BoarderColor
            cell.lblDay.textColor = .appDarkGray
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexData = self.dates?[indexPath.row] ?? ""
        if selectedDate?.contains(indexData) == true{
            let index = selectedDate?.firstIndex(of: indexData) ?? 0
            selectedDate?.remove(at: index)
        }else{
            selectedDate?.append(indexData)
        }
        
        selectDate?(selectedDate ?? [])
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 3  // 24 = 3 * spacing (8 each)
        return CGSize(width: width, height: 60)
    }
}
