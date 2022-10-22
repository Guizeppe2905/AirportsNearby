//
//  LocationService.swift
//  AirportsNearby
//
//  Created by Мария Хатунцева on 28.09.2022.
//

import CoreLocation

class LocationService: NSObject  {

    static let shared = LocationService()
    private let manager = CLLocationManager()
    private var currentLocation: (Double, Double)?
    var completion: ((CLLocation) -> Void)?
    
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestAlwaysAuthorization()
    }
    deinit {
        manager.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else {
                return
            }
            completion?(location)
            manager.stopUpdatingLocation()
        }
    
    func resolveLocationName(with location: CLLocation, completion: @escaping((String?) -> Void)) {
           let geocoder = CLGeocoder()
           geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
               guard let place = placemarks?.first, error == nil else {
                   completion(nil)
                   return
               }
              
               var name = ""
   
               if let locality = place.locality {
                   name += locality
               }
               if let location = place.location {
                   name += ", \(location)"
                   
               }
            
               UserSettings.shared.currentLat = place.location?.coordinate.latitude ?? 0.0
               UserSettings.shared.currentLon = place.location?.coordinate.longitude ?? 0.0
               completion(name)
           }
       }
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
        
    }
}
