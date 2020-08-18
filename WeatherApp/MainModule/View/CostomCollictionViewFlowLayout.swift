//
//  CostomCollictionViewFlowLayout.swift
//  WeatherApp
//
//  Created by Азизбек on 18.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import UIKit
class CostomCollictionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if !newBounds.size.equalTo(collectionView!.bounds.size) {
            itemSize = newBounds.size
            return true
        }
        return false
    }

    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let availableHight = collectionView.bounds.inset(by: collectionView.layoutMargins).height
        let maxNumColumns = Int(availableWidth / availableWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        self.itemSize = CGSize(width: cellWidth, height: availableHight)
        self.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.sectionInsetReference = .fromSafeArea
    }
}
