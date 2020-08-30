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
    var daily: DailyWeather?

    required init(cell: DailyCollectionViewCell) {
        self.cell = cell
    }
    
    func setupCell() {
        guard let daily = daily, let cell = cell else { return }
        print(daily)

      guard let dayTemp = daily.dailyTemp?.day,
        let nightTemp = daily.dailyTemp?.night,
        let icon = daily.weatherDiscription?.icon
        else { return }
        
        cell.dayTemp.text = "\(Int(dayTemp))℃"
        cell.nightTemp.text = "\(Int(nightTemp))℃"
        cell.dayOfTheWeek.text = getWeekDay()
        cell.image.image = UIImage(named: icon)
    }
    
    private func getWeekDay() -> String {
        guard let timestemp = daily?.timestamp else { return String() }
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: Double(timestemp))
        
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE")
        return dateFormatter.string(from: date)
    }
}
