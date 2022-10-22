//
//  UserSettings.swift
//  AirportsNearby
//
//  Created by Мария Хатунцева on 29.09.2022.
//

import Foundation
import CoreLocation

class UserSettings: ObservableObject {
    static let shared = UserSettings()
    @Published var currentLat: CLLocationDegrees {
        didSet {
            UserDefaults.standard.set(currentLat, forKey: "currentLat")
        }
    }
    @Published var currentLon: CLLocationDegrees {
        didSet {
            UserDefaults.standard.set(currentLon, forKey: "currentLon")
        }
    }
    init() {
        self.currentLat = UserDefaults.standard.object(forKey: "currentLat") as? CLLocationDegrees ?? 0.0
        self.currentLon = UserDefaults.standard.object(forKey: "currentLon") as? CLLocationDegrees ?? 0.0
    }
}
