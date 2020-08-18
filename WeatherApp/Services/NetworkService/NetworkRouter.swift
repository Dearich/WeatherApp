//
//  NetworkRouter.swift
//  WeatherApp
//
//  Created by Азизбек on 17.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
/* Основной функционал выполение запроса */
class NetworkRouter<EndPoint: EndPointProtocol>: NetworkRouterProtocol {

    private var task: URLSessionTask?

    func request(_ route: EndPoint, complition: @escaping NetworkRouterComplition) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { (_ data, _ response, _ error) in
                complition(data, response, nil)
            })
        } catch {
            print(error.localizedDescription)
            complition(nil, nil, error)
        }
        self.task?.resume()
    }

    fileprivate func buildRequest(from route: EntPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        request.httpMethod = route.httpMethod.rawValue
        do {
            //можно обрабатывать разного рода запросы
            switch route.task {
            case .requestWithParameters(urlParameters: let urlParameters):
                try self.configureParameters(urlParameters: urlParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
//преобразование параметров
   fileprivate func configureParameters(urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            guard let parameters = urlParameters else { throw NetworkError.parameterNil }
            try URLParameterEncoder.encode(urlRequest: &request, parameters: parameters)
        } catch {
            throw error
        }
    }

    func cancel() {
        self.task?.cancel()
    }
}
