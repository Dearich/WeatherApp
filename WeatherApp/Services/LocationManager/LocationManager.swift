//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Азизбек on 19.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

 class LocationManager {
    
    static let shared = LocationManager()
    
    func convertCoordinateToString(location: CLLocation,
                                   complition: @escaping ((_ city: String, _ country: String) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let placeMark = placemarks?.first else { return }
            // City, Country
            guard let city = placeMark.subAdministrativeArea,
                let country = placeMark.country else { return }
            complition(city, country)
        }
    }
}
