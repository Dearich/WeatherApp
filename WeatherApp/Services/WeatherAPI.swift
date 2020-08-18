//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Азизбек on 17.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation

struct WeatherAPI: EndPointProtocol {
    //TODO: init()
    var baseURL: URL {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?exclude=hourly,daily"
        guard let url = URL(string: urlString) else { fatalError("baseURL could not be configured.")}
        return url
    }

    var httpMethod: HTTPMethod { return .get }

    var task: HTTPTask {
        return .requestWithParameters(urlParameters: ["lat": NetworkManager.lat,
                                                      "lon": NetworkManager.lon,
                                                      "appid": NetworkManager.apiKey,
                                                      "units":NetworkManager.metricCall])
    }

    var headers: HTTPHeaders? { return nil }
}