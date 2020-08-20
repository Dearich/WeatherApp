//
//  DailyPresenter.swift
//  WeatherApp
//
//  Created by Азизбек on 19.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import UIKit
class DailyPresenter {
    weak var cell: DailyCollectionViewCell?
    var daily: Daily?

    required init(cell: DailyCollectionViewCell) {
        self.cell = cell
    }
    
    func setUpCell() {
        guard let daily = daily, let cell = cell else { return }
        cell.dayTemp.text = "\(Int(daily.temp.day))℃"
        cell.nightTemp.text = "\(Int(daily.temp.night))℃"
        cell.dayOfTheWeek.text = getWeekDay()
        cell.image.image = UIImage(named: daily.weather[0].icon)
        print(daily.weather[0].weatherDescription)
        print(daily.weather[0].icon)
    }
    
    private func getWeekDay() -> String {
        guard let timestemp = daily?.timestamp else { return String() }
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: Double(timestemp))
        
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE")
        return dateFormatter.string(from: date)
    }
}
