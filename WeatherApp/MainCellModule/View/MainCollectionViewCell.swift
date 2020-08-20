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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentDegreeLabel: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    private let dailyReuseIdentifier = "DailyCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        cellPresenter = CellPresenter(cell: self)
        let nib = UINib(nibName: "DailyCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: dailyReuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}
extension MainCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let daysCount = cellPresenter?.weatherModel?.daily.count else { return 0 }
        
        return daysCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dailyReuseIdentifier,
                                                            for: indexPath) as? DailyCollectionViewCell
            else { return UICollectionViewCell() }
        cell.presenter?.daily = cellPresenter?.weatherModel?.daily[indexPath.row]
        cell.presenter?.setUpCell()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}
