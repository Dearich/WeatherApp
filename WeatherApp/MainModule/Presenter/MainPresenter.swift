//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Азизбек on 18.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import UIKit

class MainPresenter: PresenterProtocol {
    
    var weather: [DailyWeather]? {
        didSet {
            guard let weather = weather else { return }
            view.weatherArray = weather
        }
    }
    
    var view: ViewProtocol
    var interactor: InteractorProtocol
    private var latitude = "59.9311"
    private var longitude = "30.3609"
    
    required init(view: ViewProtocol, interactor: InteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
     func registerForNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(createCity), name: .newWeatherFetched, object: nil)
    }
    
    @objc func createCity() {
        let weather = CoreDataStack.shared.fetchWeather()
        self.weather = weather
        
    }
}
