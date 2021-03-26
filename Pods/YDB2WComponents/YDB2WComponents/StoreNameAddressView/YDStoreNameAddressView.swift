//
//  YDStoreNameAddressView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 25/03/21.
//

import UIKit

import YDExtensions

public class YDStoreNameAddressView: UIView {
  // MARK: Properties
  private var hasButton = true
  public var callback: (() -> Void)?

  // MARK: Componentes
  private let storeNameLabel = UILabel()
  private let storeAddressLabel = UILabel()
  private let actionButton = UIButton()

  // MARK: Init
  public init(withButton: Bool) {
    super.init(frame: .zero)
    backgroundColor = UIColor.Zeplin.white
    layer.cornerRadius = 8
    hasButton = withButton
    setUpLayouts()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  @objc private func onButtonAction() {
    callback?()
  }

  public func changeValues(storeName: String?, storeAddress: String?) {
    storeNameLabel.text = storeName
    storeAddressLabel.text = storeAddress
  }
}

// MARK: Layout
extension YDStoreNameAddressView {
  private func setUpLayouts() {
    createStoreNameLabel()
    createStoreAddressLabel()

    if hasButton {
      createButton()
    }
  }

  private func createStoreNameLabel() {
    storeNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
    storeNameLabel.textAlignment = .left
    storeNameLabel.textColor = UIColor.Zeplin.black
    storeNameLabel.numberOfLines = 1
    storeNameLabel.text = .loremIpsum(ofLength: 50)
    addSubview(storeNameLabel)

    storeNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      storeNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      storeNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      storeNameLabel.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: hasButton ? -73 : -16
      ),
      storeNameLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  private func createStoreAddressLabel() {
    storeAddressLabel.font = .systemFont(ofSize: 14)
    storeAddressLabel.textAlignment = .left
    storeAddressLabel.textColor = UIColor.Zeplin.grayLight
    storeAddressLabel.numberOfLines = 1
    storeAddressLabel.text = .loremIpsum(ofLength: 50)
    addSubview(storeAddressLabel)

    storeAddressLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      storeAddressLabel.topAnchor.constraint(
        equalTo: storeNameLabel.bottomAnchor,
        constant: 3
      ),
      storeAddressLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
      storeAddressLabel.leadingAnchor.constraint(equalTo: storeNameLabel.leadingAnchor),
      storeAddressLabel.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: hasButton ? -73 : -8
      ),
      storeAddressLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  private func createButton() {
    let title = "trocar"
    let attributedString = NSMutableAttributedString(string: title)

    attributedString.addAttributes(
      [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.Zeplin.redBranding
      ],
      range: NSRange(location: 0, length: title.count)
    )

    actionButton.setAttributedTitle(attributedString, for: .normal)
    actionButton.titleEdgeInsets = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    addSubview(actionButton)

    actionButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      actionButton.widthAnchor.constraint(equalToConstant: 60),
      actionButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
      actionButton.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])

    actionButton.addTarget(self, action: #selector(onButtonAction), for: .touchUpInside)
  }
}
