//
//  YDSpaceyCardView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 10/06/21.
//

import UIKit
import YDExtensions
import YDB2WModels

public class YDSpaceyCardView: UIView {
  // MARK: Properties
  public var callback: ((_ selectedId: String?) -> Void)?
  var currentItems: [YDSpaceyComponentLiveNPSCardQuestion] = []

  // MARK: Components
  let titleLabel = UILabel()
  let skipButton = UIButton()
  let vStackView = UIStackView()
  let stackView = UIStackView()

  // MARK: Init
  public init() {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white
    layer.cornerRadius = 8
    layer.applyShadow(alpha: 0.08, y: 6, blur: 20, spread: -1)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  public func configure(with card: YDSpaceyComponentLiveNPSCard) {
    currentItems = card.children

    titleLabel.text = card.title

    for (index, item) in currentItems.enumerated() {
      let cardView = YDSpaceyInnerCardView(with: item)
      cardView.tag = index
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onAction))
      cardView.addGestureRecognizer(tapGesture)
      stackView.addArrangedSubview(cardView)
    }
  }

  public func cleanUpCard() {
    titleLabel.text = nil
    stackView.subviews.forEach { $0.removeFromSuperview() }
  }

  @objc func onSkipButton() {
    callback?(nil)
  }

  @objc func onAction(_ sender: UIGestureRecognizer) {
    guard let index = sender.view?.tag,
      let selectedItem = currentItems.at(index) else { return }
    callback?(selectedItem.id)
  }
}

// MARK: UI
extension YDSpaceyCardView {
  func configureUI() {
    configureTitleLabel()
    configureSkipButton()
    configureStackView()
  }

  func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.textColor = Zeplin.black
    titleLabel.textAlignment = .left
    titleLabel.font = .boldSystemFont(ofSize: 14)
    titleLabel.numberOfLines = 2

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor
        .constraint(equalTo: trailingAnchor, constant: 86),
      titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22)
    ])
    titleLabel.setContentCompressionResistancePriority(
      .defaultHigh,
      for: .vertical
    )
  }

  func configureSkipButton() {
    addSubview(skipButton)

    let attributedString = NSAttributedString(
      string: "PULAR",
      attributes: [
        NSAttributedString.Key.foregroundColor: UIColor.Zeplin.grayLight,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
      ]
    )

    skipButton.setAttributedTitle(attributedString, for: .normal)
    skipButton.backgroundColor = .clear

    skipButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      skipButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      skipButton.widthAnchor.constraint(equalToConstant: 70),
      skipButton.heightAnchor.constraint(equalToConstant: 40),
      skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6)
    ])
  }

  func configureStackView() {
    addSubview(vStackView)
    vStackView.alignment = .center
    vStackView.axis = .vertical

    vStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      vStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      vStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      vStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      vStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
    ])

    vStackView.addArrangedSubview(stackView)
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.spacing = 16
  }
}
