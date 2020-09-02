//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Азизбек on 17.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Decodable {
  let latitude, longitude: Double
  let current: Current
  let timezone: String
  let daily:[Daily]

  private enum CodingKeys: String, CodingKey {
    case latitude = "lat"
    case longitude = "lon"
    case current
    case timezone
    case daily
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    latitude = try container.decode(Double.self, forKey: .latitude)
    longitude = try container.decode(Double.self, forKey: .longitude)
    current = try container.decode(Current.self, forKey: .current)
    timezone = try container.decode(String.self, forKey: .timezone)
    daily = try container.decode([Daily].self, forKey: .daily)
  }
}

// MARK: - Current
struct Current: Decodable {
  let timestamp: Int
  let temp, feelsLike: Double
  let windSpeed: Double
  let weather: [Weather]

  enum CurrentCodingKeys: String, CodingKey, Decodable {
    case timestamp = "dt"
    case temp
    case feelsLike = "feels_like"
    case windSpeed = "wind_speed"
    case weather
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CurrentCodingKeys.self)
    timestamp = try container.decode(Int.self, forKey: .timestamp)
    temp = try container.decode(Double.self, forKey: .temp)
    feelsLike = try container.decode(Double.self, forKey: .feelsLike)
    windSpeed = try container.decode(Double.self, forKey: .windSpeed)
    weather = try container.decode([Weather].self, forKey: .weather)
  }
}

// MARK: - Daily
struct Daily: Decodable {
  let timestamp: Int
  let temp: Temp
  let weather: [Weather]
  let sunrise: Int
  let sunset: Int
  let humidity: Int

  enum DailyCodingKeys: String, CodingKey {
    case timestamp = "dt"
    case temp
    case weather
    case sunrise
    case sunset
    case humidity
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: DailyCodingKeys.self)
    timestamp = try container.decode(Int.self, forKey: .timestamp)
    temp = try container.decode(Temp.self, forKey: .temp)
    weather = try container.decode([Weather].self, forKey: .weather)
    sunrise = try container.decode(Int.self, forKey: .sunrise)
    sunset = try container.decode(Int.self, forKey: .sunset)
    humidity = try container.decode(Int.self, forKey: .humidity)
  }
}

// MARK: - Weather
struct Weather: Decodable {
  let identifier: Int
  let weatherDescription: String
  let icon: String

  enum CodingKeys: String, CodingKey {
    case identifier = "id"
    case weatherDescription = "description"
    case icon
  }
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    identifier = try container.decode(Int.self, forKey: .identifier)
    weatherDescription = try container.decode(String.self, forKey: .weatherDescription)
    icon = try container.decode(String.self, forKey: .icon)
  }
}

// MARK: - FeelsLike
struct FeelsLike: Decodable {
  let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Decodable {
  let day, min, max, night: Double
  let eve, morn: Double
}
