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
    
    private let fetchRequest = NSFetchRequest<AllWeather>(entityName: "AllWeather")
    
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
//        print(AllWeather)
        saveContext(container: persistentContainer)
        
    }
    
    // MARK: - Core Data Fetch
    func fetchWeather() -> [AllWeather] {
        
        do {
            let allWeather = try managedContext.fetch(fetchRequest)
            return allWeather
        } catch let error {
            print("Error with fetch data (Core Data): \(error.localizedDescription)")
        }
        return [AllWeather]()
    }
    
    // MARK: - Core Data Update
    func updateWeather(weather:WeatherModel) {
        let savedAllWeather = fetchWeather()
        for updateWeather in savedAllWeather {
            if (updateWeather.latitude == weather.latitude && updateWeather.longitude == weather.longitude ) {

//                updateWeather.setValue(weather.current, forKey: "current")
//                updateWeather.setValue(weather.daily, forKey: "daily")
            } else {
                updateWeather.setValue(weather.latitude, forKey: "latitude")
                updateWeather.setValue(weather.longitude, forKey: "longitude")
                //current
                updateWeather.current?.setValue(weather.current.temp, forKey: "temp")
                updateWeather.current?.setValue(weather.current.feelsLike, forKey: "feelsLike")
                updateWeather.current?.setValue(NSDecimalNumber(value:weather.current.timestamp), forKey: "timestamp")
                updateWeather.current?.setValue(weather.current.windSpeed, forKey: "windSpeed")
                //weather disc
                //TODO 
                //
                
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
