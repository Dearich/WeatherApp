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
    
    lazy var allDogsPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
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
    
    func saveWeather(weatherModel: WeatherModel ) {
        let managedContext = allDogsPersistentContainer.viewContext
        
        let allWeather = AllWeather(context: managedContext)
        
        allWeather.latitude = weatherModel.latitude
        allWeather.longitude = weatherModel.longitude
        
        //Current
        let currentWeather = CurrentWeather(context: managedContext)
        currentWeather.timestamp =  NSDecimalNumber(value:weatherModel.current.timestamp)
        currentWeather.temp = weatherModel.current.temp
        currentWeather.feelsLike = weatherModel.current.feelsLike
        
        // Current Weather Array
        for currentWeatherDiscription in weatherModel.current.weather {
            
            let weatherDiscription = WeatherDiscription(context: managedContext)
            weatherDiscription.id = NSDecimalNumber(value:currentWeatherDiscription.identifier)
            weatherDiscription.icon = currentWeatherDiscription.icon
            weatherDiscription.weatherDescription = currentWeatherDiscription.weatherDescription
            
            // Add To Current Weather Discription
            currentWeather.addToWeatherDiscription(weatherDiscription)
        }
        allWeather.current = currentWeather
        
        //Daily
        for day in weatherModel.daily {
            
            let dailyWeather = DailyWeather(context: managedContext)
            dailyWeather.timestamp = NSDecimalNumber(value: day.timestamp)
            
            for weather in day.weather {
                
                let weatherDiscription = WeatherDiscription(context: managedContext)
                weatherDiscription.id = NSDecimalNumber(value:weather.identifier)
                weatherDiscription.icon = weather.icon
                weatherDiscription.weatherDescription = weather.weatherDescription
                
                // Add To Daily Weather Discription
                
                dailyWeather.addToWeatherDiscription(weatherDiscription)
                
            }
            //Add To Daily Temp
            
            let temp = TempWeather(context: managedContext)
            temp.day = day.temp.day
            temp.night = day.temp.night
            dailyWeather.temp = temp
            
            //Add To All Weather Daily Weather
            allWeather.addToDaily(dailyWeather)
            
            
        }
        
        saveContext(container: allDogsPersistentContainer)
        
    }
    
}
