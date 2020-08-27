//
//  PresenterProtocol.swift
//  WeatherApp
//
//  Created by Азизбек on 18.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation

protocol PresenterProtocol: class {
    init(view: ViewProtocol, interactor: InteractorProtocol)
    var view: ViewProtocol { get }
    var interactor: InteractorProtocol { get }
    var weather: [AllWeather]? { get }
    func createCity()
}

extension PresenterProtocol {
    
}
