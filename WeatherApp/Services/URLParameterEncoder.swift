//
//  URLParameterEncoder.swift
//  WeatherApp
//
//  Created by Азизбек on 17.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation

struct URLParameterEncoder:ParameterEncoderProtocol {

    static func encode(urlRequest: inout URLRequest, parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.missingURL }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            //создание параметров и добавление в url
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            //новый url c параметрами
            urlRequest.url = urlComponents.url
        }
        //default значение заголовка, если оно не установлено
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }

}
