//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Азизбек on 18.08.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ViewProtocol {

    var presenter: PresenterProtocol?
    var weather: [WeatherModel]?
    private let reuseIdentifier = "MainCell"

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard let weatherArray = weather else { return 3 }
        return weatherArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                            for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}
