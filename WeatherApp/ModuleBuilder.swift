//
//  ModuleBuilder.swift
//  WeatherApp
//
//  Created by Азизбек on 18.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import UIKit

protocol Builder {
  static func createMain() -> UIViewController
}

class ModuleBuilder: Builder {
  static func createMain() -> UIViewController {
    let view = MainViewController()
    let interactor = MainInteractor()
    let presenter = MainPresenter(view: view, interactor: interactor)
    interactor.presenter = presenter
    view.presenter = presenter
    return view
  }
  static func createDetail() -> DetailViewController {
    let view = DetailViewController()
    let presenter = DetailPresenter(view: view)
    view.presenter = presenter
    return view
  }
}
