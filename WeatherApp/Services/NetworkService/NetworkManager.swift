//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Азизбек on 17.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation

struct NetworkManager {
    //TODO: init()
    static let apiKey = "7ae69635b68383c88ee0f24896b0e4c0"
    static let lat = "33.441792"
    static let lon = "-94.037689"
    static let metricCall = "metric"
    private let router = NetworkRouter<WeatherAPI>()

    enum Forecast {
        case current
        case minutely
        case hourly
        case daily
    }

    enum NetworkResponse: String {
        case success
        case badRequest = "Bad requet"
        case outdated = "The url you requested is outdated"
        case faild = "Network request failed"
        case noData = "Response returned with no data to decode"
        case unableToDecode = "We could not decode the response"
        case authNeed = "You need authenticated first"
    }

    enum Result<String> {
        case success
        case failure(String)
    }

    fileprivate func handleResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authNeed.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default:return .failure(NetworkResponse.faild.rawValue)
        }
    }

    func getWeather(complition: @escaping (_ weather: WeatherModel?, _ error: String?) -> Void) {
        let weatherAPI = WeatherAPI()
        router.request(weatherAPI) { (data, response, error) in
            if error != nil {
                complition(nil, "Please check your network connection.")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleResponse(response)
                print(response.statusCode)
                switch result {
                case .success:
                    guard let responseData = data else {
                        complition(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    let jsonDecoder = JSONDecoder()
                    do {
                        let apiResponse = try jsonDecoder.decode(WeatherModel.self, from: responseData)
                        complition(apiResponse, nil)
                    } catch {
                        complition(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    complition(nil, networkFailureError)
                }
            }
        }
    }
}
