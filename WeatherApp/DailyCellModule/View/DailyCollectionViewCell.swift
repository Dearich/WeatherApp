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

    @IBOutlet weak var dayOfTheWeek: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var dayTemp: UILabel!
    @IBOutlet weak var nightTemp: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        presenter = DailyPresenter(cell:self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
    }
}
