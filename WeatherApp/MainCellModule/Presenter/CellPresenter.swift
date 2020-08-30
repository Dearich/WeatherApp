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
  var weatherModel: DailyWeather?
  var dailyWeather: [DailyWeather]? {
    didSet {
      cell?.collectionView.reloadData()
    }
  }
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
    let currentDegree = weatherModel.currentTemp
    let feelsLikeDegree = weatherModel.currentFeelsLike
    let windSpeed  = weatherModel.currentWindSpeed
    guard let description = weatherModel.weatherDiscription?.weatherDescription,
      let icon = weatherModel.weatherDiscription?.icon
    else { return }

    cell.cityLabel.text = cityAndCountry.0
    cell.countryLabel.text = cityAndCountry.1
    cell.currentDegreeLabel.text = "\(Int(currentDegree))℃"
    cell.currentDescriptionLabel.text = description
    cell.windSpeedLabel.text = String(format: " %.1f m/s", windSpeed)
    cell.feelsLikeLabel.text = "\(Int(feelsLikeDegree))℃"
    cell.currentWeatherImage.image = UIImage(named: icon)
    }
  }
  private func createCityString(weather: DailyWeather?, complition: @escaping ((String, String)) -> Void) {
    guard let weather = weather else { return }
    let latitude = weather.latitude
    let longitude = weather.longitude
    let location = CLLocation(latitude: latitude, longitude: longitude)

    LocationManager.shared.convertCoordinateToString(location: location) { (city, country) in
      complition((city, country))
    }
  }
}
