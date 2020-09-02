//
//  MainCollectionViewCellDataSource.swift
//  WeatherApp
//
//  Created by Азизбек on 21.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import UIKit

protocol MainCollectionViewCellDataSourceProtocol: class {
  func pushToDetailView(with view: DetailViewController)
}

class MainCollectionViewCellDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

  weak var mainCell: MainCollectionViewCell?
  weak var mainCollectionViewCellDataSourceDelegate: MainCollectionViewCellDataSourceProtocol?

  init(cell: MainCollectionViewCell) {
    self.mainCell = cell
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let daysCount = mainCell?.cellPresenter?.dailyWeather?.count ?? 0
    return daysCount

  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCell?.dailyReuseIdentifier ?? "DailyCell",
                                                        for: indexPath) as? DailyCollectionViewCell
      else { return UICollectionViewCell() }
    guard let daily = mainCell?.cellPresenter?.dailyWeather else { return cell }
    cell.presenter?.daily = daily[indexPath.row]
    cell.presenter?.setupCell()
    return cell
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let detailView = ModuleBuilder.createDetail()
    guard let daily = mainCell?.cellPresenter?.dailyWeather else { return }
    detailView.presenter?.weather = daily[indexPath.row]
    mainCollectionViewCellDataSourceDelegate?.pushToDetailView(with: detailView)

  }
}
