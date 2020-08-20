//
//  CellPresenter.swift
//  WeatherApp
//
//  Created by Азизбек on 19.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class CellPresenter {
    
    weak var cell: MainCollectionViewCell?
    var weatherModel: WeatherModel?
    var city: String?
    var country: String?
    
    required init(cell: MainCollectionViewCell) {
        self.cell = cell
    }
    
    private func createLocation() -> CLLocation {
        guard let weatherModel = weatherModel else { return CLLocation() }
        let latitude = weatherModel.latitude
        let longitude = weatherModel.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        return location
    }
    
    func setupCell() {
        guard let weatherModel = weatherModel, let cell = cell else { return }
        createCityString(weather: weatherModel) { (cityAndCountry) in
            let currentDegree = Int(weatherModel.current.temp)
            let feelsLikeDegree = Int(weatherModel.current.feelsLike)
            let windSpeed = weatherModel.current.windSpeed
            let description = weatherModel.current.weather[0].weatherDescription
            let icon = weatherModel.current.weather[0].icon
            cell.cityLabel.text = cityAndCountry.0
            cell.countryLabel.text = cityAndCountry.1
            cell.currentDegreeLabel.text = "\(currentDegree)℃"
            cell.currentDescriptionLabel.text = description
            cell.windSpeedLabel.text = "\(windSpeed) m/s"
            cell.feelsLikeLabel.text = "\(feelsLikeDegree)℃"
            cell.currentWeatherImage.image = UIImage(named: icon)
        }
    }
    private func createCityString(weather: WeatherModel?, complition: @escaping ((String, String)) -> Void) {
        guard let weather = weather else { return }
        let latitude = weather.latitude
        let longitude = weather.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        LocationManager.convertCoordinateToString(location: location) { (city, country) in
            complition((city, country))
        }
    }
}
