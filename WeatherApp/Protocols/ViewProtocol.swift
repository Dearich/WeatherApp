//
//  ViewProtocol.swift
//  WeatherApp
//
//  Created by Азизбек on 18.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import UIKit
protocol ViewProtocol: class {
    var presenter: PresenterProtocol? { get }
    var weatherArray: [WeatherModel]? { get set }
    var cityAndCountry:[(String, String)]? { get set }
}
