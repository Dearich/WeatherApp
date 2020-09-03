//
//  DetialPresenter.swift
//  WeatherApp
//
//  Created by Азизбек on 02.09.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class DetailPresenter {
  weak var view: DetailViewController?
  var weather: DailyWeather?
  private let dateFormat = "d MMMM, EEEE"
  private let timeFormat = "HH:mm"

  required init (view: DetailViewController) {
    self.view = view
  }

  func setupView() {
    guard let weather = weather else { return }
    //Images
    view?.mainImage.image = UIImage(named: weather.weatherDiscription?.icon ?? " ")
    view?.minTempImage.image = UIImage(named: "lowTemperature")
    view?.maxTempImage.image = UIImage(named: "highTemperature")
    view?.averageTempImage.image = UIImage(named: "averageTemperature")
    view?.sunsetImage.image = UIImage(named: "sunset")
    view?.humidityImage.image = UIImage(named: "humidity")
    view?.sunriseImage.image = UIImage(named: "sunrise")

    //Labels
    view?.dateLabel.text = getDate(timestamp: weather.timestamp, dateFormate: dateFormat)
    view?.discriptionLabel.text = "\(weather.weatherDiscription?.weatherDescription ?? "no description")"
    view?.minLabel.text = "\(weather.dailyTemp?.min ?? 0) ℃"
    view?.maxLabel.text = "\(weather.dailyTemp?.max ?? 0) ℃"
    view?.eveLabel.text = "\(weather.dailyTemp?.eve ?? 0) ℃"
    view?.sunriseLabel.text = getDate(timestamp: weather.sunrise, dateFormate: timeFormat)
    view?.humidity.text = "\(weather.humidity ?? 0) %"
    view?.sunsetLabel.text = getDate(timestamp: weather.sunset, dateFormate: timeFormat)

  }

  private func getDate(timestamp: NSDecimalNumber?, dateFormate: String) -> String {
    guard let timestamp = timestamp else { return String() }
    let dateFormatter = DateFormatter()
    let date = Date(timeIntervalSince1970: Double(truncating: timestamp))

    dateFormatter.setLocalizedDateFormatFromTemplate(dateFormate)
    return dateFormatter.string(from: date)
  }

}
