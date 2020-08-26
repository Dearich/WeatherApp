//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Азизбек on 17.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation

public enum NetworkError: String, Error {
    case parameterNil = "Parameters were Nil"
    case encodingFail = "Parameters encoding fail"
    case missingURL = "URL is Nil"
}
