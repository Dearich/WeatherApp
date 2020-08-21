//
//  InteractorProtocol.swift
//  WeatherApp
//
//  Created by Азизбек on 18.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import CoreLocation

protocol  InteractorProtocol: class {
    var presenter: PresenterProtocol? { get }
    var networkManager: NetworkManager? { get set }
    func getWeather(api: WeatherAPI, complition: @escaping ((_ weather: WeatherModel?, _ error: String?) -> Void))
}
