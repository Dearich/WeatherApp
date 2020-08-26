//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Азизбек on 17.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //bachgroud
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "ru.azizbek.fetchWeather", using: nil) { (task) in
            guard let task = task as? BGAppRefreshTask else { return }
            self.handleAppRefreshTask(task: task )
        }
        return true
    }
    // will call it to start doing a background work
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        let networkManager = NetworkManager(lat: "59.9311", lon: "30.3609")
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            networkManager.cancel()// снача всегда отменям
        }
        //request
        let weatheAPI = WeatherAPI(networkManager: networkManager)
        networkManager.getWeather(weatherAPI: weatheAPI) { (weatherModel, error) in
            guard error != nil, let weather = weatherModel else { return }
            CoreDataStack.shared.saveWeather(weatherModel: weather )
        }
    }
    
    func scheduleBackgroundWeatherFetch() {
        let weatherFetchTask = BGAppRefreshTaskRequest(identifier: "ru.azizbek.fetchWeather")
        weatherFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        do {
            try BGTaskScheduler.shared.submit(weatherFetchTask)
        } catch {
            print("Unable to submit task: \(error.localizedDescription)")
        }
    }
    
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
