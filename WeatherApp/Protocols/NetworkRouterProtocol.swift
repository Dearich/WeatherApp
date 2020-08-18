//
//  NetworkRouterProtocol.swift
//  WeatherApp
//
//  Created by Азизбек on 17.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
//typealias для замыкания
public typealias NetworkRouterComplition = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkRouterProtocol: class {
    associatedtype EntPoint: EndPointProtocol
    func request(_ route: EntPoint, complition: @escaping NetworkRouterComplition)
    func cancel()
}
