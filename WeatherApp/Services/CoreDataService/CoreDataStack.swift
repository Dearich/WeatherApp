//
//  CoreDataStack.swift
//  WeatherApp
//
//  Created by Азизбек on 26.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class CoreDataStack {

  static let shared = CoreDataStack()

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "WeatherApp")
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  lazy var managedContext = persistentContainer.viewContext

  private let fetchRequest = NSFetchRequest<DailyWeather>(entityName: "DailyWeather")

  // MARK: - Core Data Saving support

  func saveContext (container: NSPersistentContainer) {
    let context = container.viewContext
    if context.hasChanges {
      do {
        try context.save()
        print("Success")
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  // MARK: - Core Data Save
  func saveWeather(weatherModel: WeatherModel ) {
    let lon = weatherModel.longitude
    let lat = weatherModel.latitude
    let location = CLLocation(latitude: lat, longitude: lon)

    LocationManager.shared.convertCoordinateToString(location: location) { [weak self] (city, country) in
      guard let self = self else { return }
      let currentWeather = DailyWeather(context: self.managedContext)

      //Current
      currentWeather.latitude = weatherModel.latitude
      currentWeather.longitude = weatherModel.longitude
      currentWeather.isCurrent = true
      currentWeather.timestamp =  NSDecimalNumber(value:weatherModel.current.timestamp)
      currentWeather.currentTemp = weatherModel.current.temp
      currentWeather.currentFeelsLike = weatherModel.current.feelsLike
      currentWeather.currentWindSpeed = weatherModel.current.windSpeed
      currentWeather.cityName = city
      currentWeather.countryName = country
      // Current Weather Array
      for currentWeatherDiscription in weatherModel.current.weather {

        let weatherDiscription = WeatherDiscription(context: self.managedContext)
        weatherDiscription.id = NSDecimalNumber(value:currentWeatherDiscription.identifier)
        weatherDiscription.icon = currentWeatherDiscription.icon
        weatherDiscription.weatherDescription = currentWeatherDiscription.weatherDescription

        // Add To Current Weather Discription
        currentWeather.weatherDiscription = weatherDiscription

      }

      //Daily
      for day in weatherModel.daily {

        let dailyWeather = DailyWeather(context: self.managedContext)
        dailyWeather.timestamp = NSDecimalNumber(value: day.timestamp)

        for weather in day.weather {

          let weatherDiscription = WeatherDiscription(context: self.managedContext)
          weatherDiscription.id = NSDecimalNumber(value:weather.identifier)
          weatherDiscription.icon = weather.icon
          weatherDiscription.weatherDescription = weather.weatherDescription
          dailyWeather.weatherDiscription = weatherDiscription
        }
        //Add To Daily Temp

        let temp = TempWeather(context: self.managedContext)
        temp.day = day.temp.day
        temp.night = day.temp.night
        dailyWeather.dailyTemp = temp
        dailyWeather.isCurrent = false
      }
      self.saveContext(container: self.persistentContainer)
    }
  }

  // MARK: - Core Data Fetch
  func fetchWeather() -> [DailyWeather] {

    do {
      let allWeather = try managedContext.fetch(fetchRequest)
      return allWeather
    } catch let error {
      print("Error with fetch data (Core Data): \(error.localizedDescription)")
    }
    return [DailyWeather]()
  }

  private func updateCurrenWeather( weather: WeatherModel,updateWeather: inout DailyWeather ) {
    updateWeather.setValue(NSDecimalNumber(value: weather.current.timestamp), forKey: "timestamp")
    updateWeather.setValue(weather.current.windSpeed, forKey: "currentWindSpeed")
    updateWeather.setValue(weather.current.temp, forKey: "currentTemp")
    updateWeather.setValue(weather.current.feelsLike, forKey: "currentFeelsLike")
    updateWeather.weatherDiscription?.setValue(weather.current.weather[0].weatherDescription, forKey: "weatherDescription")
    updateWeather.weatherDiscription?.setValue(NSDecimalNumber(value: weather.current.weather[0].identifier), forKey: "id")
    updateWeather.weatherDiscription?.setValue(weather.current.weather[0].icon, forKey: "icon")
  }

  private func firstIndex(of weather: WeatherModel,updateWeather: inout DailyWeather, index: Int ) {
    updateWeather.timestamp = NSDecimalNumber(value: weather.daily[index].timestamp)
    updateWeather.dailyTemp?.day = weather.daily[index].temp.day
    updateWeather.dailyTemp?.night = weather.daily[index].temp.night
    updateWeather.weatherDiscription?.weatherDescription = weather.daily[index].weather[0].weatherDescription
    updateWeather.weatherDiscription?.id = NSDecimalNumber(value: weather.daily[index].weather[0].identifier)
    updateWeather.weatherDiscription?.icon = weather.daily[index].weather[0].icon
  }

  // MARK: - Core Data Update
  func updateWeather(weather: WeatherModel, city: String, country: String) {
    let savedAllWeather = fetchWeather()
    let sortedSavedAllWeather = savedAllWeather.sorted { (first, second) -> Bool in
      return Int(truncating: first.timestamp ?? 0) < Int(truncating: second.timestamp ?? 0)
    }
    var index = 0
    for var updateWeather in sortedSavedAllWeather {
      if (updateWeather.latitude == weather.latitude && updateWeather.longitude == weather.longitude ) {

        //the same sity
        if updateWeather.isCurrent {
          //current
          updateCurrenWeather(weather: weather, updateWeather: &updateWeather)
        } else {
          //daily
          firstIndex(of: weather, updateWeather: &updateWeather, index: index)
          index += 1
        }

      } else {
        //a different city
        updateWeather.setValue(weather.latitude, forKey: "latitude")
        updateWeather.setValue(weather.longitude, forKey: "longitude")
        updateWeather.cityName = city
        updateWeather.countryName = country
        if updateWeather.isCurrent {
          //current
          updateCurrenWeather(weather: weather, updateWeather: &updateWeather)
        } else {
          //daily
          firstIndex(of: weather, updateWeather: &updateWeather, index: index)
          index += 1
        }
      }
      do {
        try updateWeather.managedObjectContext?.save()
      } catch let error {
        print("Error: can't update weather \n\(error.localizedDescription)")
      }
    }
  }

  // MARK: - Check Entity is Empty
  func entityIsEmpty() -> Bool {
    do {
      let count =  try managedContext.count(for: fetchRequest)
      if count == 0 {
        return true
      } else {
        return false
      }
    } catch let error {
      print("Error: \(error.localizedDescription)")
    }
    return true
  }
}
