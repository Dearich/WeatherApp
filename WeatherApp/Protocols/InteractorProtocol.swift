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
    func getImageData(iconString: String,complition: @escaping (_ data: Data?, _ error: Error?) -> Void)
}

extension InteractorProtocol {
    
    func getImageData(iconString: String,complition: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        IconDownloader.shared.downloadIcon(iconName: iconString) { (data, _, error) in
            if let error = error {
                complition(nil, error)
            }
            if let data = data {
                complition(data,nil)
            }
        }
    }
}
