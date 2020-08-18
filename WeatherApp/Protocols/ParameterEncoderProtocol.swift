//
//  ParameterEncoderProtocol.swift
//  WeatherApp
//
//  Created by Азизбек on 17.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation

/* Задача протокола кодировать параметры */

public protocol ParameterEncoderProtocol {
    static func encode(urlRequest: inout URLRequest, parameters: Parameters ) throws
}
