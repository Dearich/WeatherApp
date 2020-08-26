//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Азизбек on 18.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation

class MainPresenter: PresenterProtocol {
    
    var weather: WeatherModel? {
        didSet {
            guard let weather = weather else { return }
            view.weatherArray?.append(weather)
        }
    }
    
    var view: ViewProtocol
    var interactor: InteractorProtocol
    private var latitude = "59.9311"
    private var longitude = "30.3609"
    
    required init(view: ViewProtocol, interactor: InteractorProtocol) {
        self.view = view
        self.interactor = interactor
        createCity(latitude: latitude, longitude: longitude)
    }
    
    func createCity(latitude: String, longitude: String) {
        let networkManager = NetworkManager(lat: latitude, lon: longitude)
        let weatherAPI = WeatherAPI(networkManager: networkManager)
        interactor.networkManager = networkManager
        interactor.getWeather(api: weatherAPI) { [weak self] (weatherModel, error) in
            
            guard error == nil, let weather = weatherModel else { return }
            DispatchQueue.main.async {
                CoreDataStack.shared.saveWeather(weatherModel: weather)
                self?.weather = weather
            }
        }
    }
}
