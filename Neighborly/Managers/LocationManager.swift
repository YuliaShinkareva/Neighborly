//
//  LocationManager.swift
//  Neighborly
//
//  Created by yulias on 02/07/2024.
//

import Foundation
import MapKit
import Observation

enum LocationError: LocalizedError {
    
    case authorizationDenied
    case authorizationRestricted
    case unknownLocation
    case networkFailure
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .authorizationDenied:
            return NSLocalizedString(
                "Location access denied. Please enable location services in your settings.",
                comment: ""
            )
        case .authorizationRestricted:
            return NSLocalizedString(
                "Location access is restricted. Please check your settings.",
                comment: ""
            )
        case .unknownLocation:
            return NSLocalizedString(
                "Unable to determine your location. Please try again later.",
                comment: ""
            )
        case .networkFailure:
            return NSLocalizedString(
                "Network failure. Please check your internet connection.",
                comment: ""
            )
        case .timeout:
            return NSLocalizedString(
                "Location request timed out. Please try again.",
                comment: ""
            )
        }
    }
}

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    static let shared = LocationManager()
    var error: LocationError? = nil
    var region: MKCoordinateRegion = MKCoordinateRegion()
    
    private override init() {
        super.init()
        self.manager.delegate = self
    }
}

extension LocationManager {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: $0.coordinate.latitude,
                    longitude: $0.coordinate.longitude
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01
                )
            )
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied:
            error = .authorizationDenied
        case .restricted:
            error = .authorizationRestricted
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                self.error = .unknownLocation
            case .denied:
                self.error = .authorizationDenied
            case .network:
                self.error = .networkFailure
            case .deferredFailed:
                self.error = .timeout
            default:
                print("Unhandled CLError: \(clError.localizedDescription)")
            }
        } else {
            print("Unhandled error: \(error.localizedDescription)")
        }
    }
}

