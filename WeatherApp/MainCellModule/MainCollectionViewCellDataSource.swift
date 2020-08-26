//
//  MainCollectionViewCellDataSource.swift
//  WeatherApp
//
//  Created by Азизбек on 21.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import UIKit

class MainCollectionViewCellDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var mainCell: MainCollectionViewCell?
    
    init(cell: MainCollectionViewCell) {
        self.mainCell = cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let daysCount = mainCell?.cellPresenter?.weatherModel?.daily.count else { return 0 }
        
        return daysCount
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCell?.dailyReuseIdentifier ?? "DailyCell",
                                                            for: indexPath) as? DailyCollectionViewCell
            else { return UICollectionViewCell() }
        cell.presenter?.daily = mainCell?.cellPresenter?.weatherModel?.daily[indexPath.row]
        cell.presenter?.setupCell()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}
