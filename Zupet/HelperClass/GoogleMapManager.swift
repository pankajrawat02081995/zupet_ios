//
//  GoogleMapManager.swift
//  Zupet
//
//  Created by Pankaj Rawat on 05/09/25.
//

import UIKit
import GoogleMaps
import CoreLocation

final class MapViewController: UIViewController {
    private var mapView: GMSMapView?
    private let locationManager = CLLocationManager()
    private var locationMarker: GMSMarker?
    private var locationCircle: GMSCircle?
    private var extraMarkers: [GMSMarker] = []
    
    private let radiusMeters: CLLocationDistance = 50
    private let userDefaultsLatKey = "lastLat"
    private let userDefaultsLonKey = "lastLon"

    // MARK: - Lifecycle
    override func loadView() {
        let camera: GMSCameraPosition
        if let last = loadSavedLocation() {
            camera = GMSCameraPosition.camera(withLatitude: last.latitude,
                                              longitude: last.longitude,
                                              zoom: 17)
        } else {
            camera = GMSCameraPosition.camera(withLatitude: 20.5937,
                                              longitude: 78.9629,
                                              zoom: 14) // fallback: India
        }

        let map = GMSMapView(frame: UIScreen.main.bounds, camera: camera)
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        map.settings.compassButton = true
        map.settings.myLocationButton = false
        map.mapType = .normal

        // Disable extra layers (battery saver)
        map.isIndoorEnabled = false
        map.isTrafficEnabled = false
        map.isBuildingsEnabled = false

        self.view = map
        self.mapView = map
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // One-time location fix (battery-friendly)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cleanupMapAndReleaseMemory()
        locationManager.delegate = nil
        mapView?.removeFromSuperview()
        mapView = nil
    }

    deinit {
        cleanupMapAndReleaseMemory()
    }

    // MARK: - Map updates
    private func updateMap(for coordinate: CLLocationCoordinate2D) {
        saveLocation(coordinate)

        // User marker
        if let marker = locationMarker {
            marker.position = coordinate
        } else {
            let marker = GMSMarker(position: coordinate)
            marker.icon = imageFromXib(title: "", image: "")
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.95)
            marker.map = mapView
            locationMarker = marker
        }

        // Circle (50m)
        locationCircle?.map = nil
        let circle = GMSCircle(position: coordinate, radius: radiusMeters)
        circle.fillColor = UIColor.ThemeOrangeEnd.withAlphaComponent(0.12)
        circle.strokeColor = UIColor.ThemeOrangeEnd
        circle.strokeWidth = 1
        circle.map = mapView
        locationCircle = circle

        // Camera fit circle
        if let map = mapView {
            let bounds = coordinateBounds(center: coordinate, radius: radiusMeters)
            let update = GMSCameraUpdate.fit(bounds,
                with: UIEdgeInsets(top: 70, left: 40, bottom: 70, right: 40))
            map.moveCamera(update)
        }
    }

    func showMarkers(_ items: [MapItem]) {
        for m in extraMarkers { m.map = nil }
        extraMarkers.removeAll()

        for item in items {
            let marker = GMSMarker(position: item.coordinate)
            marker.icon = imageFromXib(title: item.title, image: item.image)
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.95)
            marker.map = mapView
            extraMarkers.append(marker)
        }
    }

    private func cleanupMapAndReleaseMemory() {
        locationMarker?.map = nil
        locationMarker = nil

        locationCircle?.map = nil
        locationCircle = nil

        for m in extraMarkers { m.map = nil }
        extraMarkers.removeAll()

        mapView?.clear()
        mapView?.delegate = nil
    }

    // MARK: - Persistence
    private func saveLocation(_ coordinate: CLLocationCoordinate2D) {
        UserDefaults.standard.set(coordinate.latitude, forKey: userDefaultsLatKey)
        UserDefaults.standard.set(coordinate.longitude, forKey: userDefaultsLonKey)
    }

    private func loadSavedLocation() -> CLLocationCoordinate2D? {
        guard
            let _ = UserDefaults.standard.object(forKey: userDefaultsLatKey),
            let _ = UserDefaults.standard.object(forKey: userDefaultsLonKey)
        else { return nil }
        let lat = UserDefaults.standard.double(forKey: userDefaultsLatKey)
        let lon = UserDefaults.standard.double(forKey: userDefaultsLonKey)
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    // MARK: - Helpers
    private func coordinateBounds(center: CLLocationCoordinate2D, radius: CLLocationDistance) -> GMSCoordinateBounds {
        let earthRadius = 6_378_137.0
        let deltaLat = (radius / earthRadius) * (180.0 / Double.pi)
        let deltaLon = deltaLat / cos(center.latitude * Double.pi / 180.0)
        let north = center.latitude + deltaLat
        let south = center.latitude - deltaLat
        let east = center.longitude + deltaLon
        let west = center.longitude - deltaLon
        let northEast = CLLocationCoordinate2D(latitude: north, longitude: east)
        let southWest = CLLocationCoordinate2D(latitude: south, longitude: west)
        return GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
    }

    private func imageFromXib(title: String, image: String?) -> UIImage {
        let view = CustomMarker.fromNib()
        view.configure(image: image, title: title)
        view.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)

        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        return renderer.image { ctx in
            view.layer.render(in: ctx.cgContext)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        } else if let last = loadSavedLocation() {
            updateMap(for: last)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        if loc.horizontalAccuracy < 0 || loc.horizontalAccuracy > 100 { return }
        updateMap(for: loc.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let last = loadSavedLocation() {
            updateMap(for: last)
        } else {
            print("Location error:", error.localizedDescription)
        }
    }
}

