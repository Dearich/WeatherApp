//
//  CoreDataStack.swift
//  WeatherApp
//
//  Created by Азизбек on 26.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import CoreData

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

    let currentWeather = DailyWeather(context: managedContext)

    //Current
    currentWeather.latitude = weatherModel.latitude
    currentWeather.longitude = weatherModel.longitude
    currentWeather.isCurrent = true
    currentWeather.timestamp =  NSDecimalNumber(value:weatherModel.current.timestamp)
    currentWeather.currentTemp = weatherModel.current.temp
    currentWeather.currentFeelsLike = weatherModel.current.feelsLike
    currentWeather.currentWindSpeed = weatherModel.current.windSpeed
    // Current Weather Array
    for currentWeatherDiscription in weatherModel.current.weather {

      let weatherDiscription = WeatherDiscription(context: managedContext)
      weatherDiscription.id = NSDecimalNumber(value:currentWeatherDiscription.identifier)
      weatherDiscription.icon = currentWeatherDiscription.icon
      weatherDiscription.weatherDescription = currentWeatherDiscription.weatherDescription

      // Add To Current Weather Discription
      currentWeather.weatherDiscription = weatherDiscription

    }

    //Daily
    for day in weatherModel.daily {

      let dailyWeather = DailyWeather(context: managedContext)
      dailyWeather.timestamp = NSDecimalNumber(value: day.timestamp)

      for weather in day.weather {

        let weatherDiscription = WeatherDiscription(context: managedContext)
        weatherDiscription.id = NSDecimalNumber(value:weather.identifier)
        weatherDiscription.icon = weather.icon
        weatherDiscription.weatherDescription = weather.weatherDescription
        dailyWeather.weatherDiscription = weatherDiscription
      }
      //Add To Daily Temp

      let temp = TempWeather(context: managedContext)
      temp.day = day.temp.day
      temp.night = day.temp.night
      dailyWeather.dailyTemp = temp
      dailyWeather.isCurrent = false
    }
    saveContext(container: persistentContainer)

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

  private func updateDailyWeather( weather: WeatherModel,updateWeather: inout DailyWeather ) {
    for daily in weather.daily {
      updateWeather.dailyTemp?.setValue(daily.temp.day, forKey: "day")
      updateWeather.dailyTemp?.setValue(daily.temp.night, forKey: "night")
      updateWeather.weatherDiscription?.setValue(daily.weather[0].weatherDescription, forKey: "weatherDescription")
      updateWeather.weatherDiscription?.setValue(NSDecimalNumber(value: daily.weather[0].identifier), forKey: "id")
      updateWeather.weatherDiscription?.setValue(daily.weather[0].icon, forKey: "icon")

    }
  }

  // MARK: - Core Data Update
  func updateWeather(weather:WeatherModel) {
    let savedAllWeather = fetchWeather()
    for var updateWeather in savedAllWeather {
      if (updateWeather.latitude == weather.latitude && updateWeather.longitude == weather.longitude ) {

        //the same sity
        if updateWeather.isCurrent {
          //current
          updateCurrenWeather(weather: weather, updateWeather: &updateWeather)

        } else {
          //daily
          updateDailyWeather(weather: weather, updateWeather: &updateWeather)
        }

      } else {
        //a different city
        updateWeather.setValue(weather.latitude, forKey: "latitude")
        updateWeather.setValue(weather.longitude, forKey: "longitude")
        if updateWeather.isCurrent {
          //current
          updateCurrenWeather(weather: weather, updateWeather: &updateWeather)
        } else {
          //daily
          updateDailyWeather(weather: weather, updateWeather: &updateWeather)
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
