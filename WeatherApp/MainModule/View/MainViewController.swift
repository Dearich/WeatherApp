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

    var weatherArray: [AllWeather]? {
        didSet {
            self.collectionView.reloadData()
            
            if let weatherArray = weatherArray?.isEmpty, !weatherArray {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
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
        return weatherArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                            for: indexPath) as? MainCollectionViewCell
            else { return UICollectionViewCell() }
        pageControl.currentPage = indexPath.row
        
        guard let weatherArray = weatherArray else { return UICollectionViewCell() }
        let weather = weatherArray[indexPath.row]
        cell.cellPresenter?.weatherModel = weather
        cell.cellPresenter?.setupCell()
        return cell
    }
}
