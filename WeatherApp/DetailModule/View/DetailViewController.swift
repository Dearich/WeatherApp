//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Азизбек on 02.09.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  var presenter: DetailPresenter?

  //MARK: - Labels
  var dateLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = .boldSystemFont(ofSize: 19)
    return label
  }()

  var minLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()

  var maxLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  var eveLabel: UILabel  = {
    let label = UILabel(frame: .zero)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  let discriptionLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  var sunsetLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  var sunriseLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  var humidity: UILabel = {
    let label = UILabel(frame: .zero)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  // MARK: - UIImageViews
  var mainImage: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    return image
  }()

  var minTempImage: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    return image
  }()

  var maxTempImage: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    return image
  }()

  var averageTempImage: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    return image
  }()

  var sunriseImage: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    return image
  }()

  var sunsetImage: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    return image
  }()

  var humidityImage: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    return image
  }()

  //MARK: - Funcs
  override func viewDidLoad() {
    super.viewDidLoad()
    //    mainSetup()
    setupViewWithVisualFormat()
  }

  func createVerticalSrack(imageView: UIImageView, label: UILabel) -> UIStackView {
    let stackView   = UIStackView()
    stackView.axis  = NSLayoutConstraint.Axis.vertical
    stackView.distribution  = UIStackView.Distribution.fillEqually
    stackView.alignment = UIStackView.Alignment.fill
    stackView.spacing   = 10.0

    stackView.addArrangedSubview(imageView)
    //    imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    stackView.addArrangedSubview(label)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }

  func createStack(views: [UIView],distribution: UIStackView.Distribution, axis: NSLayoutConstraint.Axis) -> UIStackView {
    let stackView   = UIStackView()
    stackView.axis  = axis
    stackView.distribution  = distribution
    stackView.alignment = UIStackView.Alignment.fill
    stackView.spacing   = 10.0
    for view in views {
      stackView.addArrangedSubview(view)
    }

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }

  func mainSetup() {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(blurEffectView)
    //date label
    view.addSubview(dateLabel)
    dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
    dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    dateLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    dateLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

    let minStack = createVerticalSrack(imageView: minTempImage, label: minLabel)
    let averageStack = createVerticalSrack(imageView: averageTempImage, label: eveLabel)
    let maxStack = createVerticalSrack(imageView: maxTempImage, label: maxLabel)

    let sunriseStack = createVerticalSrack(imageView: sunriseImage, label: sunriseLabel)
    let humidityStack = createVerticalSrack(imageView: humidityImage, label: humidity)
    let sunsetStack = createVerticalSrack(imageView: sunsetImage, label: sunsetLabel)

    let horizontalStack = createStack(views: [minStack, averageStack, maxStack], distribution: .fillEqually, axis:.horizontal)
    let horizontalSecondStack = createStack(views: [sunriseStack, humidityStack, sunsetStack], distribution: .fillEqually, axis:.horizontal)
    let mainStackView = createStack(views: [mainImage, discriptionLabel, horizontalStack, horizontalSecondStack],
                                    distribution: .fillEqually,
                                    axis: .vertical)

    view.addSubview(mainStackView)
    mainStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
    mainStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  -100).isActive = true
    mainStackView.topAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.bottomAnchor, constant: 50).isActive = true

    presenter?.setupView()
  }

  func setupViewWithVisualFormat() {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(blurEffectView)

    view.addSubview(dateLabel)
    dateLabel.addConstraintsWithFormat(format: "H:|-[v0]-|", views: dateLabel)
    dateLabel.addConstraintsWithFormat(format: "V:|-20-[v0(50)]", views: dateLabel)

    view.addSubview(mainImage)
    mainImage.addConstraintsWithFormat(format: "H:|-70-[v0]-70-|", views: mainImage)
    mainImage.addConstraintsWithFormat(format: "V:[v0]-20-[v1(150)]", views: dateLabel, mainImage)

    view.addSubview(discriptionLabel)
    discriptionLabel.addConstraintsWithFormat(format: "H:|-[v0]-|", views: discriptionLabel)
    discriptionLabel.addConstraintsWithFormat(format: "V:[v0]-20-[v1(50)]", views: mainImage, discriptionLabel)

    setupTreeInRow(minTempImage, averageTempImage, maxTempImage, discriptionLabel)
    setupTreeInRow(minLabel, eveLabel, maxLabel, averageTempImage)
    setupTreeInRow(sunriseImage, humidityImage, sunsetImage, eveLabel)
    setupTreeInRow(sunriseLabel, humidity, sunsetLabel, humidityImage)
    presenter?.setupView()
  }
  
  private func setupTreeInRow(_ view0: UIView, _ view2: UIView, _ view3: UIView, _ mainView: UIView) {

    view.addSubview(view0)
    view.addSubview(view2)
    view.addSubview(view3)

    view0.addConstraintsWithFormat(format: "H:|-[v0(==v1)]-10-[v1(==v2)]-10-[v2]-|", views: view0, view2, view3)
    view2.addConstraintsWithFormat(format: "V:[v0]-20-[v1(50)]", views: mainView, view2)
    view0.addConstraintsWithFormat(format: "V:[v0]-20-[v1(50)]", views: mainView, view0)
    view3.addConstraintsWithFormat(format: "V:[v0]-20-[v1(50)]", views: mainView, view3)
  }

}

extension UIView {

  func addConstraintsWithFormat(format: String, views: UIView...) {
    var viewDictinary = [String: UIView]()
    for (index, view) in views.enumerated() {
      let key = "v\(index)"
      viewDictinary[key] = view
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: format,
                                                               options: NSLayoutConstraint.FormatOptions(),
                                                               metrics: nil,
                                                               views: viewDictinary))

  }
}
