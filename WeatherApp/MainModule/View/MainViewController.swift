//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Азизбек on 18.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ViewProtocol {
    
    var cityAndCountry: [(String, String)]?
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: PresenterProtocol?
    var weatherArray: [WeatherModel]? {
        didSet {
            cityAndCountry = [(String, String)]()
            collectionView.reloadData()
            print("MainViewController")
            pageControl.numberOfPages = weatherArray!.count
            
        }
    }
    
    private let reuseIdentifier = "MainCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherArray = [WeatherModel]()
        let nib = UINib(nibName: "MainCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
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
        
        guard let weatherArray = weatherArray else { return UICollectionViewCell() }
        let weather = weatherArray[indexPath.row]
        cell.cellPresenter?.weatherModel = weather
        cell.cellPresenter?.setupCell()
        return cell
    }
}
