//
//  DailyCollectionViewCell.swift
//  WeatherApp
//
//  Created by Азизбек on 19.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
    var presenter: DailyPresenter?
    override func awakeFromNib() {
        super.awakeFromNib()
        presenter = DailyPresenter(cell:self)
    }
}
