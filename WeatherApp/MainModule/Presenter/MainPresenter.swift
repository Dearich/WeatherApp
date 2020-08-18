//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Азизбек on 18.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation

class MainPresenter: PresenterProtocol {

    var view: ViewProtocol
    var interactor: InteractorProtocol

    required init(view: ViewProtocol, interactor: InteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
}
