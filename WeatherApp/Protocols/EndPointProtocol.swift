//
//  EndPointProtocol.swift
//  WeatherApp
//
//  Created by Азизбек on 17.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
/*
 Основной протокол собирающий все компоненты запроса
 */
protocol EndPointProtocol {
    var baseURL: URL { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
