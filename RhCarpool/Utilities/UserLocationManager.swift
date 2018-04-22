//
//  UserLocationManager.swift
//  RhCarpool
//
//  Created by Ravi on 21/04/18.
//  Copyright © 2018 ThinkAnts. All rights reserved.
//

import Foundation
import MapKit

class UserLocationManager: NSObject, CLLocationManagerDelegate {
    static let SharedManager = UserLocationManager()
    private var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var locationAuthorizeStatus: CLAuthorizationStatus?
    var updateLocationHandler: ((_ locationValue: CLLocation) -> Void)?
    private override init () {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    func getCurrentLocation() -> CLLocation? {
        if !CLLocationManager.locationServicesEnabled() {
            return nil
        }
        if self.locationManager.location != nil {
            return self.locationManager.location
        }
        if currentLocation != nil {
            return currentLocation!
        }
        return nil
    }
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        if let locationObj = locationArray.lastObject as? CLLocation {
            currentLocation = locationObj
            if self.updateLocationHandler != nil {
                self.updateLocationHandler!(locationObj)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        locationAuthorizeStatus = status
    }
}
