//
//  YDReplyMessageComponent+Layouts.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 13/05/21.
//

import UIKit

import YDExtensions
import YDB2WAssets

extension YDReplyMessageComponent {
  func configureLayout() {
    backgroundColor = .clear
    translatesAutoresizingMaskIntoConstraints = false
    clipsToBounds = true

    configureContainerView()
    configureLeftView()
    configureUsernameLabel()
    configureActionButton()
    configureMessageLabel()
    configureArrowIcon()
  }

  // Container
  func configureContainerView() {
    addSubview(container)
    container.backgroundColor = Zeplin.redPale
    container.layer.masksToBounds = true

    container.translatesAutoresizingMaskIntoConstraints = false
    leadingContainerConstraint.isActive = true
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: topAnchor),
      container.trailingAnchor.constraint(equalTo: trailingAnchor),
      container.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  // Left red view
  func configureLeftView() {
    container.addSubview(leftView)
    leftView.backgroundColor = Zeplin.redBranding

    leftView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      leftView.topAnchor.constraint(equalTo: container.topAnchor),
      leftView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      leftView.widthAnchor.constraint(equalToConstant: 4),
      leftView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])
  }

  // Username label
  func configureUsernameLabel() {
    container.addSubview(usernameLabel)

    usernameLabel.font = .systemFont(ofSize: 12).bold().italic()
    usernameLabel.textColor = Zeplin.grayLight
    usernameLabel.textAlignment = .left

    usernameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      usernameLabel.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: 8),
      usernameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
    ])
    usernameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    usernameLabel.setContentCompressionResistancePriority(
      .defaultHigh,
      for: .horizontal
    )
  }

  // Message label
  func configureMessageLabel() {
    container.addSubview(messageLabel)

    messageLabel.font = .italicSystemFont(ofSize: 12)
    messageLabel.textColor = Zeplin.grayLight
    messageLabel.textAlignment = .left

    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    trailingMessageConstraint.isActive = true
    NSLayoutConstraint.activate([
      messageLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 6),
      messageLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
    ])
    messageLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    messageLabel.setContentCompressionResistancePriority(
      .defaultLow,
      for: .horizontal
    )
  }

  // Action button
  func configureActionButton() {
    container.addSubview(actionButton)
    actionButton.tintColor = Zeplin.grayLight
    actionButton.setImage(Icons.times, for: .normal)

    actionButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      actionButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      actionButton.widthAnchor.constraint(equalToConstant: 34),
      actionButton.heightAnchor.constraint(equalToConstant: 34),
      actionButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -17)
    ])

    actionButton.addTarget(self, action: #selector(onActionButton), for: .touchUpInside)
  }

  // Arrow icon imageView
  func configureArrowIcon() {
    addSubview(arrowIcon)
    arrowIcon.isHidden = true

    arrowIcon.tintColor = Zeplin.grayNight
    arrowIcon.image = Icons.curvedRightArrow

    arrowIcon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      arrowIcon.trailingAnchor.constraint(
        equalTo: container.leadingAnchor,
        constant: -8
      ),
      arrowIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
      arrowIcon.widthAnchor.constraint(equalToConstant: 28),
      arrowIcon.heightAnchor.constraint(equalToConstant: 28)
    ])
  }
}

//
private extension UIFont {

  //Add Traits
  func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
    let symTraits = fontDescriptor.symbolicTraits
    let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(arrayLiteral: symTraits, traits))
    return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
  }

  func bold() -> UIFont {
    return withTraits(traits: .traitBold)
  }

  func italic() -> UIFont {
    return withTraits(traits: .traitItalic)
  }
}
