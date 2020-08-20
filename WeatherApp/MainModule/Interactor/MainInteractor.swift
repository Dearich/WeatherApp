//
//  MainInteractor.swift
//  WeatherApp
//
//  Created by Азизбек on 18.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import CoreLocation

class MainInteractor: InteractorProtocol {
    
    var networkManager: NetworkManager?
    weak var presenter: PresenterProtocol?
    
    func getWeather(api: WeatherAPI, complition: @escaping ((WeatherModel?, String?) -> Void)) {
        guard let networkManager = networkManager else { return }
        DispatchQueue.global().async {
            networkManager.getWeather(weatherAPI: api) { (weather, error) in
                if error != nil {
                    complition(nil, error)
                }
                if weather != nil {
                    complition(weather, nil)
                }
            }
        }
    }
}
