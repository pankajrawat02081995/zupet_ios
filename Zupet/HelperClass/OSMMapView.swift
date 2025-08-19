import UIKit
import MapboxMaps
import CoreLocation

final class MapBoxView: UIView, CLLocationManagerDelegate {
    
    // MARK: - Properties
    private(set) var mapView: MapView!
    private let locationManager = CLLocationManager()
    
    private var circleSourceId = "radius-source"
    private var circleLayerId = "radius-layer"
    private var userMarkerManager: PointAnnotationManager?
    private var markersManager: PointAnnotationManager?
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        setupMap()
    }
    
    // MARK: - Setup Map
    private func setupMap() {
        let token = Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String
        ?? "pk.eyJ1IjoicmFwaWRvcmlkZSIsImEiOiJjbTM4N3puZjgwamJoMmxxdXJydGZ5MDRhIn0.V-ietHaPTyJjkNXsyngVyw"
        
        MapboxOptions.accessToken = token
        
        let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090),
                                          zoom: 17)
        let mapInitOptions = MapInitOptions(cameraOptions: cameraOptions, styleURI: .streets)
        
        mapView = MapView(frame: bounds, mapInitOptions: mapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(mapView)
        
        // Hide Mapbox UI
        mapView.ornaments.logoView.isHidden = true
        mapView.ornaments.attributionButton.isHidden = true
        mapView.ornaments.compassView.isHidden = true
        mapView.ornaments.scaleBarView.isHidden = true
        
        // Disable default puck
        mapView.location.options.puckType = nil
        
        // Location manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Gestures
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        // Marker managers
        markersManager = mapView.annotations.makePointAnnotationManager(id: "markers-manager")
        userMarkerManager = mapView.annotations.makePointAnnotationManager(id: "user-marker-manager")
    }
    
    // MARK: - Handle Tap
    @objc private func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mapView)
        let coordinate = mapView.mapboxMap.coordinate(for: point)
        print("📍 Tapped at: \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    // MARK: - Add Custom Marker
    func addMarker(at coordinate: CLLocationCoordinate2D,
                   userImage: UIImage? = nil,
                   rate: String? = nil) {
        guard let markersManager else { return }
        
        var point = PointAnnotation(coordinate: coordinate)
        
        // Create custom marker image with optional user image + rate text
        let markerImage = makeCustomMarker(userImage: userImage, rate: rate)
        point.image = .init(image: markerImage, name: UUID().uuidString)
        
        markersManager.annotations.append(point)
    }
    
    // Custom marker drawing (lightweight, reuses context)
    private func makeCustomMarker(userImage: UIImage?, rate: String?) -> UIImage {
        let size = CGSize(width: 60, height: 70)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        
        // Marker background
        UIColor.white.setFill()
        UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height - 10),
                     cornerRadius: 12).fill()
        
        // Draw user image (circle)
        if let img = userImage {
            let rect = CGRect(x: 5, y: 5, width: 50, height: 50)
            UIBezierPath(ovalIn: rect).addClip()
            img.draw(in: rect)
        }
        
        // Draw rate label
        if let rate {
            let textRect = CGRect(x: 0, y: 55, width: size.width, height: 14)
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 12),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraph
            ]
            rate.draw(in: textRect, withAttributes: attrs)
        }
        
        ctx?.restoreGState()
        let finalImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return finalImage
    }
    
    // MARK: - Add Radius Overlay
    func addRadiusOverlay(center: CLLocationCoordinate2D, radiusMeters: Double) {
        mapView.mapboxMap.onNext(event: .styleLoaded) { [weak self] _ in
            guard let self else { return }
            let style = self.mapView.mapboxMap.style
            
            let circleCoordinates = self.makeCircleCoordinates(center: center, radiusMeters: radiusMeters)
            let polygon = Polygon([circleCoordinates])
            let feature = Feature(geometry: .polygon(polygon))
            
            if style.sourceExists(withId: self.circleSourceId) {
                try? style.updateGeoJSONSource(withId: self.circleSourceId, geoJSON: .feature(feature))
            } else {
                var source = GeoJSONSource(id: self.circleSourceId)
                source.data = .feature(feature)
                try? style.addSource(source)
                
                var fillLayer = FillLayer(id: self.circleLayerId, source: self.circleSourceId)
                fillLayer.fillColor = .constant(StyleColor(.ThemeOrangeEnd.withAlphaComponent(0.2)))
                fillLayer.fillOutlineColor = .constant(StyleColor(.ThemeOrangeEnd))
                try? style.addLayer(fillLayer)
            }
            
            // Keep user marker centered
            self.addUserMarker(at: center)
        }
    }
    
    // MARK: - User Marker
    private func addUserMarker(at coordinate: CLLocationCoordinate2D) {
        guard let userMarkerManager else { return }
        userMarkerManager.annotations.removeAll()
        
        let userIcon = UIImage(named: "ic_current_location") ?? {
            // fallback dot
            let dotSize: CGFloat = 16
            UIGraphicsBeginImageContextWithOptions(CGSize(width: dotSize, height: dotSize), false, 0)
            UIColor.ThemeOrangeEnd.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: dotSize, height: dotSize)).fill()
            let img = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
            UIGraphicsEndImageContext()
            return img
        }()
        
        var annotation = PointAnnotation(coordinate: coordinate)
        annotation.image = .init(image: userIcon, name: "user-location")
        userMarkerManager.annotations = [annotation]
    }
    
    // MARK: - Circle Coordinates
    private func makeCircleCoordinates(center: CLLocationCoordinate2D,
                                       radiusMeters: Double,
                                       segments: Int = 64) -> [CLLocationCoordinate2D] {
        let distRadians = radiusMeters / 6_371_000.0
        let centerLat = center.latitude * .pi / 180
        let centerLon = center.longitude * .pi / 180
        
        return (0...segments).map { i in
            let bearing = Double(i) * (2 * .pi / Double(segments))
            let lat = asin(sin(centerLat) * cos(distRadians) + cos(centerLat) * sin(distRadians) * cos(bearing))
            let lon = centerLon + atan2(sin(bearing) * sin(distRadians) * cos(centerLat),
                                        cos(distRadians) - sin(centerLat) * sin(lat))
            return CLLocationCoordinate2D(latitude: lat * 180 / .pi, longitude: lon * 180 / .pi)
        }
    }
    
    // MARK: - Location Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        
        // Always follow current location
        mapView.mapboxMap.setCamera(to: CameraOptions(center: loc.coordinate, zoom: 16))
        
        // Update user marker & radius
        addRadiusOverlay(center: loc.coordinate, radiusMeters: 1000)
    }

    // MARK: - After Permission
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            if let loc = manager.location {
                // Set initial camera once at zoom 16
                mapView.mapboxMap.setCamera(to: CameraOptions(center: loc.coordinate, zoom: 16))
                addRadiusOverlay(center: loc.coordinate, radiusMeters: 1000)
            }
            manager.startUpdatingLocation()
        default:
            break
        }
    }

}
