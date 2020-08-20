//
//  IconDownloader.swift
//  WeatherApp
//
//  Created by Азизбек on 20.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
class IconDownloader {
    
    static let shared = IconDownloader()
    
    func downloadIcon(iconName: String, complition: @escaping NetworkRouterComplition){
        let urlString = "http://openweathermap.org/img/wn/\(iconName)@3x.png"
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let session = URLSession.shared
       let task = session.dataTask(with: request, completionHandler: { (_ data, _ response, _ error) in
            if let error = error {
                complition(nil, nil, error)
            }
            if let data = data {
                complition(data, response, nil)
            }
        })
        task.resume()
    }
}
