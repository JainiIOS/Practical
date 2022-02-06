//
//  LocationService.swift
//  Practical
//
//  Created by a on 06/02/22.
//

import UIKit
import CoreLocation

class LocationService: NSObject {

    var locationManager: CLLocationManager?
    var lastUserLocation: CLLocation?
    var currentUserLocation: ((CLLocation) -> ())?
    var changeAuthorizationSuccess : (() -> ())?
    var locationTrack: (([CLLocation]) -> ())?
    var isLocationFetched: Bool = false
    
    var isRemainToTakeLocationPermision: Bool {
        return (locationManager?.authorizationStatus == .notDetermined || locationManager?.authorizationStatus == .denied || locationManager?.authorizationStatus == .restricted) //Location permision popup displayed?
    }

    var isLocationPermissionGiven : Bool {
        if CLLocationManager.locationServicesEnabled() {
            if locationManager?.authorizationStatus == .authorizedAlways || locationManager?.authorizationStatus == .authorizedWhenInUse {
                return true
            }
        }
        return false
    }

    static let shared = LocationService()

    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.allowsBackgroundLocationUpdates = false
        locationManager?.delegate = self
        //locationManager?.requestAlwaysAuthorization()
    }
    
    func startLocationUpdate() {
        locationManager?.startUpdatingLocation()
    }

    func stopLocationUpdate() {
        locationManager?.stopUpdatingLocation()
    }
}

//MARK:- CLLocationManagerDelegate Methods
extension LocationService: CLLocationManagerDelegate {

    //for iOS 15
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .notDetermined:
                locationManager?.requestWhenInUseAuthorization()
                break
            case .authorizedAlways , .authorizedWhenInUse:
                locationManager?.startUpdatingLocation()
                self.changeAuthorizationSuccess?()
                break
            case .denied , .restricted:
                //self.openPermissionPopuop()
                locationManager?.stopUpdatingLocation()
                break
            default:
                break
        }
        
        switch manager.accuracyAuthorization {
            case .fullAccuracy:
                break
            case .reducedAccuracy:
                break
            default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        isLocationFetched = false
        switch status {
            case .notDetermined:
                locationManager?.requestWhenInUseAuthorization()
            case .restricted, .denied:
                //self.openPermissionPopuop()
                locationManager?.stopUpdatingLocation()
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager?.startUpdatingLocation()
                self.changeAuthorizationSuccess?()
        @unknown default: break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let aLocation = locations.last {
            currentLocation = aLocation
            currentUserLocation?(aLocation)
        }
        
        if let locValue = manager.location?.coordinate {
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            DBHelper.storeLocations(lat: locValue.latitude, long: locValue.longitude, currentTime: String(NSDate().timeIntervalSince1970))
            locationTrack?(locations)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: Failed to get User current Location \(error.localizedDescription)")
    }
}
