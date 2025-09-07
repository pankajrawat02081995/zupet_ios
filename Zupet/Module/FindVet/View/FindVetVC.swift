//
//  FindVetVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 14/08/25.
//

import UIKit
import CoreLocation
import GoogleMaps

// MARK: - Model
struct MapItem {
    let coordinate: CLLocationCoordinate2D
    let title: String
    let image: String?
}

// MARK: - ViewController
final class FindVetVC: UIViewController {
    
    // MARK: - Outlets (mapView is a plain UIView container in storyboard)
    @IBOutlet private weak var lblTitle: UILabel! {
        didSet { lblTitle.font = .manropeBold(18) }
    }
    @IBOutlet weak var filterCollection: UICollectionView!
    @IBOutlet private weak var txtSearch: UITextField! {
        didSet { txtSearch.font = .manropeMedium(14) }
    }
    @IBOutlet private weak var btnViewAll: UIButton! {
        didSet { btnViewAll.titleLabel?.font = .manropeMedium(12) }
    }
    @IBOutlet private weak var lblNearVets: UILabel! {
        didSet { lblNearVets.font = .manropeBold(18) }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var mapView: UIView! // <-- storyboard container
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var bgView: UIView!
    
    // MARK: - Properties
    private var lastBgViewSize: CGSize = .zero
    private var viewModel: FindVetViewModel?
    
    // Real GMSMapView instance (created/destroyed programmatically)
    private var gmsMapView: GMSMapView?
    
    // Live markers on the map (GMSMarker objects)
    private var extraMarkers: [GMSMarker] = []
    // Models for the markers - keep this to persist/restore state
    private var currentMapItems: [MapItem] = []
    
    // User overlay references (so we can remove without clearing all markers if needed)
    private var userCircle: GMSCircle?
    private var userMarker: GMSMarker?
    
    // Simple in-memory cache for quick restore (no disk)
    private static var cachedCamera: GMSCameraPosition?
    private static var cachedMarkers: [MapItem] = []
    private var filterOptions : [String] = ["Emergency","Top Rated","Under 5 Km"]
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = FindVetViewModel(view: self)
        txtSearch.addTarget(self, action: #selector(self.searchOnTap(_:)), for: .editingDidBegin)
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // fetch location and create map there (camera uses returned location)
        fetchUserLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // if we had cached camera & markers (from back button), try to restore map state
        if let cam = Self.cachedCamera, gmsMapView == nil {
            // if we don't yet have real location result we still create map with cached camera center
            createMapIfNeeded(camera: cam)
            if !Self.cachedMarkers.isEmpty {
                showMarkers(Self.cachedMarkers)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Save camera & markers (for back navigation restore)
        if let cam = gmsMapView?.camera {
            Self.cachedCamera = cam
        }
        Self.cachedMarkers = currentMapItems
        releaseMapAndResources()
    }
    
    deinit {
        Log.debug("🧹 FindVetVC deinitialized")
    }
    
    func setupView(){
        btnViewAll.isHidden = viewModel?.vetModel?.data?.count ?? 0 >= 5 ? false : true
        lblNearVets.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if bgView.bounds.size != lastBgViewSize {
            lastBgViewSize = bgView.bounds.size
            bgView.applyDiagonalGradient()
            bgView.updateGradientFrameIfNeeded()
        }
        
        // Ensure any created map fills the container if size changed
        if let gmap = gmsMapView {
            gmap.frame = mapView.bounds
        }
    }
    
    // MARK: - Actions
    @objc private func searchOnTap(_ sender: UITextField) {
        push(VetNearMeVC.self, from: .vet)
    }
    
    @IBAction private func viewAllOnPress(_ sender: UIButton) {
        push(VetNearMeVC.self, from: .vet) { _ in }
    }
    
    @IBAction private func backOnPress(_ sender: UIButton) {
        // Save camera & markers (already done in viewWillDisappear)
        popView()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: VetXIB.self)
        
        filterCollection.delegate = self
        filterCollection.dataSource = self
        filterCollection.register(cellType: TimeXIB.self)
    }
    
    // MARK: - Map Creation / Configuration
    
    /// Create map using a coordinate (typical flow after fetching user location)
    private func createMapIfNeeded(location: CLLocationCoordinate2D) {
        // If there's already a GMSMapView, nothing to do
        guard gmsMapView == nil else { return }
        
        // Use cached camera if present (preserve zoom/position), else create from location
        let camera: GMSCameraPosition
        if let cached = Self.cachedCamera {
            camera = cached
        } else {
            camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                              longitude: location.longitude,
                                              zoom: 13)
        }
        
        let newMap = GMSMapView(frame: mapView.bounds, camera: camera)
        newMap.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newMap.settings.myLocationButton = false
        newMap.settings.compassButton = true
        newMap.isBuildingsEnabled = false
        newMap.isIndoorEnabled = false
        newMap.isTrafficEnabled = false
        newMap.setMinZoom(2, maxZoom: 20)
        newMap.delegate = self
        mapView.addSubview(newMap)
        gmsMapView = newMap
        
        // restore markers if we cached them earlier
        if !Self.cachedMarkers.isEmpty {
            currentMapItems = Self.cachedMarkers
            showMarkers(Self.cachedMarkers)
            Self.cachedMarkers.removeAll()
        } else if !currentMapItems.isEmpty {
            showMarkers(currentMapItems)
        }
        
        configureMapAppearance()
    }
    
    /// Create map using a prepared camera (used when restoring cachedCamera)
    private func createMapIfNeeded(camera: GMSCameraPosition) {
        guard gmsMapView == nil else { return }
        
        let newMap = GMSMapView(frame: mapView.bounds, camera: camera)
        newMap.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newMap.settings.myLocationButton = false
        newMap.settings.compassButton = true
        newMap.isBuildingsEnabled = false
        newMap.isIndoorEnabled = false
        newMap.isTrafficEnabled = false
        newMap.setMinZoom(2, maxZoom: 20)
        newMap.delegate = self
        mapView.addSubview(newMap)
        gmsMapView = newMap
        
        if !currentMapItems.isEmpty {
            showMarkers(currentMapItems)
        }
        
        configureMapAppearance()
    }
    
    private func configureMapAppearance() {
        // Defensive: ensure gmsMapView exists
        guard let map = gmsMapView else { return }
        map.mapType = .normal
        map.settings.myLocationButton = false
        map.settings.compassButton = true
        map.isBuildingsEnabled = false
        map.isIndoorEnabled = false
        map.isTrafficEnabled = false
        map.setMinZoom(2, maxZoom: 20)
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Location fetch
    private func fetchUserLocation() {
        LocationService.shared.getUserLocation { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let loc):
                let coord = CLLocationCoordinate2D(latitude: loc.latitude ?? 0.0,
                                                   longitude: loc.longitude ?? 0.0)
                // create map with this location if needed
                self.createMapIfNeeded(location: coord)
                self.focusOnUserLocation(coord, color: .ThemeOrangeEnd)
                // load markers from view model (example)
                self.viewModel?.getVets(radius: 5000, location: loc)
            case .failure(let error):
                Log.error("❌ Location error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UICollectionView
extension FindVetVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel?.vetModel?.data?.count ?? 0
        return collectionView == filterCollection ? filterOptions.count : min(count, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollection{
            let cell:TimeXIB = collectionView.dequeueReusableCell(for: indexPath)
            let indexData = filterOptions[indexPath.row]
            cell.lblTime.text = indexData
            cell.lblTime.font = .manropeBold(12)
            cell.lblTime.cornerRadius = 8
            return cell
        }else{
            let cell: VetXIB = collectionView.dequeueReusableCell(for: indexPath)
            if let indexData = viewModel?.vetModel?.data?[indexPath.row] {
                cell.imgUser.setImage(from: indexData.photos?.first ?? "")
                cell.lblName.text = indexData.name
                cell.lblRate.text = "\(indexData.rating ?? 0.0)(\(indexData.totalReviews ?? 0))"
                cell.lblAddress.text = indexData.address
                
                let status = OpeningHoursHelper.status(openingTime: indexData.openingTime,
                                                       closingTime: indexData.closingTime)
                cell.lblOpen.text = status.openText
                cell.lblOpen.textColor = status.openColor
                cell.lblCloseTime.text = status.closeText
                cell.lblCloseTime.textColor = status.closeColor
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == filterCollection{
            let indexData = filterOptions[indexPath.row]
            
            // Calculate width based on the label text
            let labelFont = UIFont.manropeBold(12) // replace with your label font
            let labelWidth = widthForLabel(text: indexData, font: labelFont, height: collectionView.bounds.height)
            
            return CGSize(width: labelWidth, height: collectionView.bounds.height)
        }else{
            return CGSize(width: collectionView.bounds.width / 1.2, height: collectionView.bounds.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollection{
            
        }else{
            push(VetDetailsVC.self, from: .vet) { [weak self] vc in
                guard let self = self,
                      let indexData = self.viewModel?.vetModel?.data?[indexPath.row] else { return }
                vc.vetID = indexData.id ?? ""
            }
        }
    }
    
    func widthForLabel(text: String, font: UIFont, height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return ceil(boundingBox.width) + 50 // Add some padding
    }
    
}

// MARK: - Marker Handling (optimized)
extension FindVetVC {
    
    /// Public: show markers (stores the models to currentMapItems so we can restore later)
    func showMarkers(_ items: [MapItem]) {
        // Save models
        currentMapItems = items
        
        // Remove old markers from map properly
        for m in extraMarkers { m.map = nil }
        extraMarkers.removeAll()
        
        guard let map = gmsMapView else {
            // If map not created yet, keep currentMapItems and it will be added when map created
            return
        }
        
        // Create new markers using rendered UIImage icons (lower memory/energy)
        for item in items {
            let marker = GMSMarker(position: item.coordinate)
            let icon = imageFromMarkerXib(title: item.title, image: item.image)
            marker.icon = icon
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.95)
            marker.map = map
            extraMarkers.append(marker)
        }
    }
}

// MARK: - Current Location + Radius (optimized)
extension FindVetVC {
    /// Focus map to user location, add 50m colored circle + user icon, re-add markers
    func focusOnUserLocation(_ location: CLLocationCoordinate2D,
                             showMarker: Bool = true,
                             radiusMeters: CLLocationDistance = 50,
                             color: UIColor = .systemBlue) {
        // Ensure map exists
        if gmsMapView == nil {
            createMapIfNeeded(location: location)
        }
        guard let map = gmsMapView else { return }
        
        // Remove previous user overlays only (keep extraMarkers array intact)
        userCircle?.map = nil
        userMarker?.map = nil
        userCircle = nil
        userMarker = nil
        
        // Limit zooms to reasonable range
        map.setMinZoom(10, maxZoom: 18)
        
        // Circle
        let circle = GMSCircle(position: location, radius: radiusMeters)
        circle.fillColor = color.withAlphaComponent(0.12)
        circle.strokeColor = color.withAlphaComponent(0.9)
        circle.strokeWidth = 2
        circle.map = map
        userCircle = circle
        
        // User marker
        if showMarker {
            let iconImage = UIImage(named: "ic_current_location") ?? imageFromMarkerXib(title: "You", image: nil, size: CGSize(width: 48, height: 48))
            let m = GMSMarker(position: location)
            m.icon = iconImage
            m.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            m.map = map
            userMarker = m
        }
        
        // Re-add extra markers (they might have been removed due to map.clear())
        if !extraMarkers.isEmpty {
            for marker in extraMarkers {
                marker.map = map
            }
        } else if currentMapItems.isEmpty {
            // example placeholder markers (if you need)
            setMarker()
        } else {
            // restore from models
            showMarkers(currentMapItems)
        }
        
        // Animate camera center + fixed zoom
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: 18)
        map.animate(to: camera)
    }
}

// MARK: - Map Resource Management
extension FindVetVC {
    
    /// Frees heavy map & GPU resources. Call when leaving the screen.
    private func releaseMapAndResources() {
        // 1) Remove user overlays
        userCircle?.map = nil
        userCircle = nil
        userMarker?.map = nil
        userMarker = nil
        
        // 2) Remove markers
        for m in extraMarkers { m.map = nil }
        extraMarkers.removeAll()
        
        // 3) Clear map internal overlays and caches (if map exists)
        if let map = gmsMapView {
            map.clear()                 // remove overlays managed by map
            map.delegate = nil          // remove delegate to avoid retain cycles
            map.removeFromSuperview()   // remove from container view
        }
        
        // 4) Finally remove our reference so ARC can dealloc
        gmsMapView = nil
        
        // Do not wipe cached camera/markers here — keep them if you want restore on next appear
    }
}

// MARK: - Helpers / Example Markers
extension FindVetVC {
    func setMarker() {
        let items: [MapItem] = [
            MapItem(
                coordinate: CLLocationCoordinate2D(latitude: 30.1290, longitude: 77.2674), // Yamuna Nagar Center
                title: "4.0",
                image: "https://avatar.iran.liara.run/public/33"
            ),
            MapItem(
                coordinate: CLLocationCoordinate2D(latitude: 30.1345, longitude: 77.2800), // ~2 km NE
                title: "4.2",
                image: "https://avatar.iran.liara.run/public/33"
            ),
            MapItem(
                coordinate: CLLocationCoordinate2D(latitude: 30.1200, longitude: 77.2550), // ~2.5 km SW
                title: "4.5",
                image: "https://avatar.iran.liara.run/public/33"
            ),
            MapItem(
                coordinate: CLLocationCoordinate2D(latitude: 30.1400, longitude: 77.2600), // ~3 km N
                title: "4.1",
                image: "https://avatar.iran.liara.run/public/33"
            ),
            MapItem(
                coordinate: CLLocationCoordinate2D(latitude: 30.1250, longitude: 77.2900), // ~4.5 km E
                title: "4.3",
                image: "https://avatar.iran.liara.run/public/33")
            
        ]
        showMarkers(items)
    }
}

// MARK: - GMSMapViewDelegate (optional, keep if you use delegate callbacks)
extension FindVetVC: GMSMapViewDelegate {
    // Implement map delegate methods if needed, keep them lightweight and avoid heavy work in callbacks.
}
