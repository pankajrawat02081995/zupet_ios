//
//  FindVetVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 14/08/25.
//

import UIKit
import CoreLocation
import MapboxMaps

class FindVetVC: UIViewController {
    
    @IBOutlet private weak var lblTitle: UILabel! {
        didSet {
            lblTitle.font = .manropeBold(18)
        }
    }

    @IBOutlet weak var txtSearch: UITextField!{
        didSet{
            txtSearch.font = .manropeMedium(14)
        }
    }
    
    @IBOutlet weak var btnViewAll: UIButton!{
        didSet{
            btnViewAll.titleLabel?.font = .manropeMedium(12)
        }
    }
    @IBOutlet weak var lblNearVets: UILabel!{
        didSet{
            lblNearVets.font = .manropeBold(18)
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MapBoxView!
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bgView: UIView!
    
    // To avoid reapplying gradient unnecessarily
    private var lastBgViewSize: CGSize = .zero
    private var locationManager = CLLocationManager()
    private var circleLayerId = "radius-layer"
    private var circleSourceId = "radius-source"
    
    private var viewModel : FindVetViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FindVetViewModel(view: self)
        
        LocationService.shared.getUserLocation { result in
            switch result {
            case .success(let location):
                self.viewModel?.getVets(radius: 5000, location: location)
            case .failure(let error):
                Log.error("❌ Error: \(error.localizedDescription)")
            }
        }
        
        
        txtSearch.addTarget(self, action: #selector(self.searchOnTap(_:)), for: .editingDidBegin)
        setupCollectionView()
        // Add multiple markers
        ////        mapView.addMarker(at: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090))
        //        mapView.addMarker(at: CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025))
        //
        //                // Add radius on first location
        //        mapView.addRadiusOverlay(center: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090), radiusMeters: 50)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Apply gradient only when size changes (better performance)
        if bgView.bounds.size != lastBgViewSize {
            lastBgViewSize = bgView.bounds.size
            bgView.applyDiagonalGradient()
            bgView.updateGradientFrameIfNeeded()
        }
    }
    
    func setupView(){
        btnViewAll.isHidden = viewModel?.vetModel?.data?.count ?? 0 >= 5 ? false : true
        lblNearVets.isHidden = false
    }
    
    @objc func searchOnTap(_ sender : UITextField){
        push(VetNearMeVC.self, from: .vet)
    }
    
    @IBAction func viewAllOnPress(_ sender: UIButton) {
        push(VetNearMeVC.self, from: .vet){ [weak self] vc in
            guard let self = self else {return}
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        popView()
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: VetXIB.self)
    }
    
}

extension FindVetVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel?.vetModel?.data?.count ?? 0
        return count >= 5 ? 5 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : VetXIB = collectionView.dequeueReusableCell(for: indexPath)
        let indexData = viewModel?.vetModel?.data?[indexPath.row]
        cell.imgUser.setImage(from: indexData?.photos?.first ?? "")
        cell.lblName.text = indexData?.name ?? ""
        cell.lblRate.text = "\(indexData?.rating ?? 0.0)(\(indexData?.totalReviews ?? 0))"
        cell.lblAddress.text = indexData?.address ?? ""
        
        let status = OpeningHoursHelper.status(openingTime: indexData?.openingTime ?? "", closingTime: indexData?.closingTime ?? "")

        cell.lblOpen.text = status.openText
        cell.lblOpen.textColor = status.openColor

        cell.lblCloseTime.text = status.closeText
        cell.lblCloseTime.textColor = status.closeColor

        return cell
    }
    
    // ✅ Make each cell size equal to collectionView’s size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 1.2, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        push(VetDetailsVC.self, from: .vet){ [weak self] vc in
            guard let self = self else {return}
            let indexData = viewModel?.vetModel?.data?[indexPath.row]
            vc.vetID = indexData?.id ?? ""
        }
    }
}

struct OpenCloseUI {
    let openText: String
    let openColor: UIColor
    let closeText: String
    let closeColor: UIColor
}

enum OpeningHoursHelper {
    private static let parseFormats = ["H:mm", "HH:mm", "h:mm a", "hh:mm a"]

    private static func parseTime(_ timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        for f in parseFormats {
            formatter.dateFormat = f
            if let date = formatter.date(from: timeString) {
                return date
            }
        }
        return nil
    }

    private static func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // always show 12hr format with AM/PM
        return formatter.string(from: date)
    }

    static func status(openingTime: String?, closingTime: String?) -> OpenCloseUI {
        guard let openStr = openingTime?.trimmingCharacters(in: .whitespacesAndNewlines),
              let closeStr = closingTime?.trimmingCharacters(in: .whitespacesAndNewlines),
              let openDate = parseTime(openStr),
              let closeDate = parseTime(closeStr)
        else {
            return OpenCloseUI(openText: "Closed",
                               openColor: .red,
                               closeText: "Closed",
                               closeColor: .red)
        }

        let calendar = Calendar.current
        let openComp = calendar.dateComponents([.hour, .minute], from: openDate)
        let closeComp = calendar.dateComponents([.hour, .minute], from: closeDate)
        let now = Date()
        let nowComp = calendar.dateComponents([.hour, .minute], from: now)

        let openMinutes = (openComp.hour ?? 0) * 60 + (openComp.minute ?? 0)
        let closeMinutes = (closeComp.hour ?? 0) * 60 + (closeComp.minute ?? 0)
        let nowMinutes = (nowComp.hour ?? 0) * 60 + (nowComp.minute ?? 0)

        let isOpen: Bool
        if openMinutes <= closeMinutes {
            isOpen = (nowMinutes >= openMinutes && nowMinutes < closeMinutes)
        } else {
            // Overnight case
            isOpen = (nowMinutes >= openMinutes || nowMinutes < closeMinutes)
        }

        if isOpen {
            return OpenCloseUI(
                openText: "Open",
                openColor: .systemGreen,
                closeText: "Closes at \(formatTime(closeDate))",
                closeColor: .darkGray
            )
        } else {
            return OpenCloseUI(
                openText: "Opens at \(formatTime(openDate))",
                openColor: .darkGray,
                closeText: "Closed",
                closeColor: .red
            )
        }
    }
}

