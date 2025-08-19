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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtSearch.addTarget(self, action: #selector(self.searchOnTap(_:)), for: .editingDidBegin)
        setupCollectionView()
        // Add multiple markers
//        mapView.addMarker(at: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090))
        mapView.addMarker(at: CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025))

                // Add radius on first location
        mapView.addRadiusOverlay(center: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090), radiusMeters: 50)
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
    
    @objc func searchOnTap(_ sender : UITextField){
        push(VetNearMeVC.self, from: .vet)
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
        return 5 // Change to your count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : VetXIB = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
    // ✅ Make each cell size equal to collectionView’s size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 1.3, height: collectionView.bounds.height)
    }
}
