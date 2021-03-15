//
//  LoadFailCollectionViewCell.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 14/03/21.
//

import UIKit

import YDExtensions

class LoadFailCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  var callback: (() -> Void)?

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    callback = nil
    super.prepareForReuse()
  }

  // MARK: Actions
  @objc func onActionButton() {
    callback?()
  }
}

// MARK: Layout
extension LoadFailCollectionViewCell {
  func setUpLayout() {
    backgroundColor = .clear

    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])

    contentView.backgroundColor = UIColor.Zeplin.white
    contentView.layer.applyShadow(alpha: 0.15, x: 0, y: 0, blur: 20)
    contentView.layer.cornerRadius = 6
    contentView.layer.masksToBounds = false

    layer.masksToBounds = false

    createErrorLabel()
    createActionButton()
  }

  func createErrorLabel() {
    let errorLabel = UILabel()
    errorLabel.font = .systemFont(ofSize: 14)
    errorLabel.textAlignment = .center
    errorLabel.textColor = UIColor.Zeplin.grayLight
    errorLabel.numberOfLines = 1
    errorLabel.text = "Ops! Falha ao carregar."
    contentView.addSubview(errorLabel)

    errorLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      errorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      errorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    ])
  }

  func createActionButton() {
    let actionButton = UIButton()
    actionButton.titleLabel?.font = .systemFont(ofSize: 14)
    actionButton.setTitleColor(UIColor.Zeplin.redBranding, for: .normal)
    actionButton.setTitle("atualizar", for: .normal)
    contentView.addSubview(actionButton)

    actionButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      actionButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
      actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      actionButton.heightAnchor.constraint(equalToConstant: 35),
      actionButton.widthAnchor.constraint(equalToConstant: 100)
    ])

    actionButton.addTarget(self, action: #selector(onActionButton), for: .touchUpInside)
  }
}
