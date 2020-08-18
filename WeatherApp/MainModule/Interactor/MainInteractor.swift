//
//  MainInteractor.swift
//  WeatherApp
//
//  Created by Азизбек on 18.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation

class MainInteractor: InteractorProtocol {

    weak var presenter: PresenterProtocol?

    func getWeather(complition: @escaping (([WeatherModel]?, String?) -> Void)) {
    }

}
