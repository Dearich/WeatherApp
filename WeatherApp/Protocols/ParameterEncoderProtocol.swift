//
//  ParameterEncoderProtocol.swift
//  WeatherApp
//
//  Created by Азизбек on 17.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation

/** Задача протокола кодировать параметры
 encode(urlRequest: inout URLRequest, parameters: Parameters ) - принемает и возвращает один
 и тотже URLRequest объект добавляя в него параметры ( parameters )
 */

public protocol ParameterEncoderProtocol {
    static func encode(urlRequest: inout URLRequest, parameters: Parameters ) throws
}
