//
//  MainCollectionViewCell.swift
//  WeatherApp
//
//  Created by Азизбек on 17.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    var cellPresenter: CellPresenter?
    var mainCollectionViewCellDataSource: MainCollectionViewCellDataSource?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentDegreeLabel: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    let dailyReuseIdentifier = "DailyCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        cellPresenter = CellPresenter(cell: self)
        mainCollectionViewCellDataSource = MainCollectionViewCellDataSource(cell: self)
        let nib = UINib(nibName: "DailyCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: dailyReuseIdentifier)
        collectionView.dataSource = mainCollectionViewCellDataSource
        collectionView.delegate = mainCollectionViewCellDataSource
    }
}
