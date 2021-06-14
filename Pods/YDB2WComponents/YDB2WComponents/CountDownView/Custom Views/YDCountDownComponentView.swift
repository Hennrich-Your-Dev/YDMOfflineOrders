//
//  YDCountDownComponentView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 09/06/21.
//

import UIKit
import YDExtensions

class YDCountDownComponentView: UIView {
  // MARK: Components
  let leftNumberView = UIView()
  let leftNumberLabel = UILabel()
  let rightNumberView = UIView()
  let rightNumberLabel = UILabel()
  let descriptionLabel = UILabel()

  // MARK: Init
  init(description: String) {
    super.init(frame: .zero)
    configureUI()
    descriptionLabel.text = description
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: UI
extension YDCountDownComponentView {
  func configureUI() {
    let views = [
      leftNumberView,
      rightNumberView,
      descriptionLabel
    ]

    views.forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    configureLeftView()
    configureRightView()
    configureDescriptionLabel()
  }

  func configureLeftView() {
    leftNumberView.backgroundColor = Zeplin.redPale
    leftNumberView.layer.cornerRadius = 2

    NSLayoutConstraint.activate([
      leftNumberView.topAnchor.constraint(equalTo: topAnchor),
      leftNumberView.leadingAnchor.constraint(equalTo: leadingAnchor),
      leftNumberView.widthAnchor.constraint(equalToConstant: 24),
      leftNumberView.heightAnchor.constraint(equalToConstant: 34)
    ])

    leftNumberView.addSubview(leftNumberLabel)
    leftNumberLabel.font = .boldSystemFont(ofSize: 20)
    leftNumberLabel.textColor = Zeplin.redNight
    leftNumberLabel.textAlignment = .center
    leftNumberLabel.text = "0"

    leftNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      leftNumberLabel.centerXAnchor.constraint(equalTo: leftNumberView.centerXAnchor),
      leftNumberLabel.centerYAnchor.constraint(equalTo: leftNumberView.centerYAnchor)
    ])
  }

  func configureRightView() {
    rightNumberView.backgroundColor = Zeplin.redPale
    rightNumberView.layer.cornerRadius = 2

    NSLayoutConstraint.activate([
      rightNumberView.topAnchor.constraint(equalTo: topAnchor),
      rightNumberView.leadingAnchor
        .constraint(equalTo: leftNumberView.trailingAnchor, constant: 2),
      rightNumberView.trailingAnchor.constraint(equalTo: trailingAnchor),
      rightNumberView.widthAnchor.constraint(equalToConstant: 24),
      rightNumberView.heightAnchor.constraint(equalToConstant: 34)
    ])

    rightNumberView.addSubview(rightNumberLabel)
    rightNumberLabel.font = .boldSystemFont(ofSize: 20)
    rightNumberLabel.textColor = Zeplin.redNight
    rightNumberLabel.textAlignment = .center
    rightNumberLabel.text = "0"

    rightNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      rightNumberLabel.centerXAnchor.constraint(equalTo: rightNumberView.centerXAnchor),
      rightNumberLabel.centerYAnchor.constraint(equalTo: rightNumberView.centerYAnchor)
    ])
  }

  func configureDescriptionLabel() {
    descriptionLabel.textColor = Zeplin.grayLight
    descriptionLabel.textAlignment = .center
    descriptionLabel.font = .systemFont(ofSize: 10, weight: .medium)

    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: leftNumberView.bottomAnchor, constant: 6),
      descriptionLabel.leadingAnchor.constraint(equalTo: leftNumberView.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: rightNumberView.trailingAnchor),
      descriptionLabel.heightAnchor.constraint(equalToConstant: 12),
      descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}

