//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Азизбек on 17.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit
import BackgroundTasks
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  let locationManager = CLLocationManager()

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    locationManager.requestWhenInUseAuthorization()
    //foreground
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }

    UIApplication.shared.setMinimumBackgroundFetchInterval(3600)
    //        //backgroud
    //        BGTaskScheduler.shared.register(forTaskWithIdentifier: "ru.azizbek.fetchWeather", using: nil) { (task) in
    //            guard let task = task as? BGAppRefreshTask else { return }
    //            self.handleAppRefreshTask(task: task )
    //            print("Background mode!!!")
    //        }

    return true
  }
  func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    let oldWeather = CoreDataStack.shared.fetchWeather()
    for weather in oldWeather where weather.isCurrent {
      let latitude = String(weather.latitude)
      let longitude = String(weather.longitude)
      let networkManager = NetworkManager(lat: latitude, lon: longitude)
      let weatheAPI = WeatherAPI(networkManager: networkManager)
      networkManager.getWeather(weatherAPI: weatheAPI) { (weatherModel, error) in
        guard error == nil, let unwrappedWeather = weatherModel else { return }
        if CoreDataStack.shared.entityIsEmpty() {
          CoreDataStack.shared.saveWeather(weatherModel: unwrappedWeather)
          NotificationCenter.default.post(name: .newWeatherFetched, object: nil)
        } else {
          //             CoreDataStack.shared.updateWeather(weather: unwrappedWeather)
          NotificationCenter.default.post(name: .newWeatherFetched, object: nil)
        }
      }
    }

  }

  // will call it to start doing a background work
  //    func handleAppRefreshTask(task: BGAppRefreshTask) {
  //        print("Background mode!!!")
  //        guard let location = locationManager.location else { return }
  //        let latitude = String(location.coordinate.latitude)
  //        let longitude = String(location.coordinate.longitude)
  //        let networkManager = NetworkManager(lat: latitude, lon: longitude)
  //        task.expirationHandler = {
  //            task.setTaskCompleted(success: false)
  //            networkManager.cancel()// снача всегда отменям
  //        }
  //        //request
  //        let weatheAPI = WeatherAPI(networkManager: networkManager)
  //        networkManager.getWeather(weatherAPI: weatheAPI) { (weatherModel, error) in
  //            guard error == nil, let unwrappedWeather = weatherModel else { return }
  //            if CoreDataStack.shared.entityIsEmpty() {
  //                CoreDataStack.shared.saveWeather(weatherModel: unwrappedWeather)
  //                NotificationCenter.default.post(name: .newWeatherFetched, object: nil)
  //            } else {
  //                CoreDataStack.shared.updateWeather(weather: unwrappedWeather)
  //                NotificationCenter.default.post(name: .newWeatherFetched, object: nil)
  //            }
  //            task.setTaskCompleted(success: true)
  //        }
  //        scheduleBackgroundWeatherFetch()
  //    }

  //request for background task
  //    func scheduleBackgroundWeatherFetch() {
  //        print("Background mode!!!")
  //        let weatherFetchTask = BGAppRefreshTaskRequest(identifier: "ru.azizbek.fetchWeather")
  //        weatherFetchTask.earliestBeginDate = nil
  //        do {
  //            try BGTaskScheduler.shared.submit(weatherFetchTask)
  //        } catch {
  //            print("Unable to submit task: \(error.localizedDescription)")
  //        }
  //    }

  // MARK: - UISceneSession Lifecycle

  func application(_ application: UIApplication,
                   configurationForConnecting connectingSceneSession: UISceneSession,
                   options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    /*If any sessions were discarded while the application was not running,
     this will be called shortly after application:didFinishLaunchingWithOptions.
     Use this method to release any resources that were specific to the discarded scenes, as they will not return.*/
  }

}
extension AppDelegate: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    print("didUpdateLocations")
    let latitude = String(locValue.latitude)
    let longitude = String(locValue.longitude)
    let networkManager = NetworkManager(lat: latitude, lon: longitude)
    let weatherAPI = WeatherAPI(networkManager: networkManager)
    networkManager.getWeather(weatherAPI: weatherAPI, completion: { (weatherModel, error) in
      guard error == nil, let unwrappedWeather = weatherModel else { return }
      DispatchQueue.main.async {
        if CoreDataStack.shared.entityIsEmpty() {
          CoreDataStack.shared.saveWeather(weatherModel: unwrappedWeather)
          NotificationCenter.default.post(name: .newWeatherFetched, object: nil)

        } else {
          let location = CLLocation(latitude: weatherModel?.latitude ?? 0, longitude: weatherModel?.longitude ?? 0)
          LocationManager.shared.convertCoordinateToString(location: location) {[weak self] (city, country) in
            CoreDataStack.shared.updateWeather(weather: unwrappedWeather, city: city, country: country)
            NotificationCenter.default.post(name: .newWeatherFetched, object: nil)

          }
        }
      }
    })
  }
}
extension Notification.Name {
  static let newWeatherFetched = Notification.Name("ru.azizbek.newWeatherFetched")
}
