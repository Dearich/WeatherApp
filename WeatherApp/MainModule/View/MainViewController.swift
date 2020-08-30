//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Азизбек on 18.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ViewProtocol {

  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  var presenter: PresenterProtocol?
  var dailyWeather: [DailyWeather]?
  var currentWeather: [DailyWeather]?

  var weatherArray: [DailyWeather]? {
    didSet {
      self.collectionView.reloadData()
      guard let weatherArray = weatherArray else { return }
      dailyWeather = [DailyWeather]()
      currentWeather = [DailyWeather]()
      if  !weatherArray.isEmpty {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        for daily in weatherArray {
          if !daily.isCurrent {
            dailyWeather?.append(daily)
          } else {
            currentWeather?.append(daily)
          }
        }
      }
    }
  }

  private let reuseIdentifier = "MainCell"

  override func viewDidLoad() {
    super.viewDidLoad()
    activityIndicator.startAnimating()
    let nib = UINib(nibName: "MainCollectionViewCell", bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.dataSource = self
    collectionView.delegate = self
    guard let presenter = presenter as? MainPresenter else { return }
    presenter.registerForNotification()
    if !CoreDataStack.shared.entityIsEmpty() {
      NotificationCenter.default.post(name: .newWeatherFetched, object: nil)
    }
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    appDelegate.locationManager.startUpdatingLocation()
  }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  // MARK: UICollectionViewDataSource

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let weatherArray = weatherArray else { return 0 }
    var count = 0
    _ = weatherArray.compactMap { (element) in
      if element.isCurrent {
        count += 1
      }
    }
    return count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                        for: indexPath) as? MainCollectionViewCell
      else { return UICollectionViewCell() }
    pageControl.currentPage = indexPath.row

    guard let weather = currentWeather?[indexPath.row] else { return UICollectionViewCell() }
    cell.cellPresenter?.weatherModel = weather
    cell.cellPresenter?.setupCell()
    cell.cellPresenter?.dailyWeather = dailyWeather
    return cell
  }
}
