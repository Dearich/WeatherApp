//
//  DailyPresenter.swift
//  WeatherApp
//
//  Created by Азизбек on 19.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
class DailyPresenter {
    weak var cell: DailyCollectionViewCell?
    var daily: Daily?

    required init(cell: DailyCollectionViewCell) {
        self.cell = cell
    }
    
    func setUpCell() {
        print(daily)
    }
}
