//
//  HTTPTask.swift
//  WeatherApp
//
//  Created by Азизбек on 17.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
/**
 HTTPHeaders - typealias для словаря заголовков запроса
 Parameters - typealias для параметров запроса
 */
public typealias HTTPHeaders = [String:String]
public typealias Parameters = [String:Any]

/**
 requestWithParameters(urlParameters:) - функция позваляющая создать запрос с параметрами, принамает словарь параметров
 */
public enum HTTPTask {
    case requestWithParameters(urlParameters: Parameters?)
}
