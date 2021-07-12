//
//  YDNextLiveView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 05/07/21.
//

import UIKit
import YDB2WModels
import YDB2WAssets
import YDExtensions
import YDUtilities

public class YDNextLiveView: UIView {
  // MARK: Properties
  var views: [UIView] = []
  var hasButton = true

  public var callback: (() -> Void)?
  public var stateView: UIStateEnum = .normal {
    didSet {
      changeUIState(with: stateView)
    }
  }

  // MARK: Components
  let photoBackgroundView = UIView()
  let photoImageView = UIImageView()
  let dateLabel = UILabel()
  let nameLabel = UILabel()
  let descriptionLabel = UILabel()
  let scheduleButton = UIButton()

  // MARK: Init
  public init() {
    super.init(frame: .zero)
    configureLayout()
  }

  public init(hasButton: Bool) {
    super.init(frame: .zero)
    self.hasButton = hasButton
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  public func cleanUp() {
    photoImageView.image = Icons.imagePlaceHolder?
      .withAlignmentRectInsets(
        UIEdgeInsets(top: -16, left: -16, bottom: -16, right: -16)
      )
    dateLabel.text = nil
    nameLabel.text = nil
    descriptionLabel.text = nil
    callback = nil
    stateView = .normal
  }

  public func config(with live: YDSpaceyComponentNextLive?) {
    guard let live = live else { return }

    photoImageView.setImage(
      live.photo,
      placeholder: Icons.imagePlaceHolder?
        .withAlignmentRectInsets(
          UIEdgeInsets(top: -16, left: -16, bottom: -16, right: -16)
        )
    )
    dateLabel.text = live.formatedDate
    nameLabel.text = live.name
    descriptionLabel.text = live.description
    setStyle(isAvailable: live.isAvailable, isLive: live.isLive)
  }

  public func setStyle(isAvailable: Bool, isLive: Bool) {
    dateLabel.textColor = isAvailable ? Zeplin.grayLight: Zeplin.redNight
    dateLabel.textColor = isLive ?
      Zeplin.redNight :
      Zeplin.grayLight

    if !hasButton { return }

    scheduleButton.tintColor = isAvailable ? Zeplin.redBranding : Zeplin.grayLight
    scheduleButton.setAttributedTitle(
      NSAttributedString(
        string: isAvailable ? "adicionar" :
          isLive ? "adicionar" : "adicionado",
        attributes: [
          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
          NSAttributedString.Key.foregroundColor: isAvailable ?
            Zeplin.redBranding : Zeplin.grayNight
        ]
      ),
      for: .normal
    )
    scheduleButton.isEnabled = isAvailable
  }

  @objc func onButtonAction() {
    callback?()
  }
}

// MARK: UIState Delegate
extension YDNextLiveView: UIStateDelegate {
  public func changeUIState(with type: UIStateEnum) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      if type == .normal {
        self.views.forEach { $0.stopShimmer() }
      } else if type == .loading {
        self.views.forEach { $0.startShimmer() }
      }
    }
  }
}

// MARK: UI
extension YDNextLiveView {
  private func configureLayout() {
    configureView()
    configurePhotoImageView()
    configureDateLabel()
    configureNameLabel()
    configureDescriptionLabel()

    if !hasButton { return }

    configureScheduleButton()
  }

  private func configureView() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = Zeplin.white
    layer.applyShadow(alpha: 0.08, y: 6, blur: 20, spread: -1)
    layer.cornerRadius = 6
  }

  // Photo
  private func configurePhotoImageView() {
    addSubview(photoBackgroundView)
    views.append(photoBackgroundView)

    photoBackgroundView.layer.cornerRadius = 4
    photoBackgroundView.layer.masksToBounds = true
    photoBackgroundView.backgroundColor = Zeplin.graySurface

    photoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoBackgroundView.widthAnchor.constraint(equalToConstant: 116),
      photoBackgroundView.heightAnchor.constraint(equalToConstant: 116),
      photoBackgroundView.topAnchor
        .constraint(equalTo: topAnchor, constant: 10),
      photoBackgroundView.leadingAnchor
        .constraint(equalTo: leadingAnchor, constant: 10),
      photoBackgroundView.bottomAnchor
        .constraint(equalTo: bottomAnchor, constant: -16)
    ])

    addSubview(photoImageView)
    photoImageView.layer.cornerRadius = 4
    photoImageView.layer.masksToBounds = true
    photoImageView.image = Icons.imagePlaceHolder?
      .withAlignmentRectInsets(
        UIEdgeInsets(top: -16, left: -16, bottom: -16, right: -16)
      )
    photoImageView.tintColor = UIColor.Zeplin.grayNight
    photoImageView.contentMode = .scaleAspectFill

    photoImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoImageView.widthAnchor.constraint(equalToConstant: 116),
      photoImageView.heightAnchor.constraint(equalToConstant: 116),
      photoImageView.centerXAnchor
        .constraint(equalTo: photoBackgroundView.centerXAnchor),
      photoImageView.centerYAnchor
        .constraint(equalTo: photoBackgroundView.centerYAnchor)
    ])
  }

  // Date
  private func configureDateLabel() {
    addSubview(dateLabel)
    views.append(dateLabel)

    dateLabel.textColor = Zeplin.grayLight
    dateLabel.font = .boldSystemFont(ofSize: 12)
    dateLabel.textAlignment = .left

    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
      dateLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 12),
      dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      dateLabel.heightAnchor.constraint(equalToConstant: 14)
    ])
  }

  // Name
  private func configureNameLabel() {
    addSubview(nameLabel)
    views.append(nameLabel)

    nameLabel.textColor = Zeplin.black
    nameLabel.font = .boldSystemFont(ofSize: 16)
    nameLabel.textAlignment = .left

    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
      nameLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
      nameLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
      nameLabel.heightAnchor.constraint(equalToConstant: 19)
    ])
  }

  // Description
  private func configureDescriptionLabel() {
    addSubview(descriptionLabel)
    views.append(descriptionLabel)

    descriptionLabel.textColor = Zeplin.grayLight
    descriptionLabel.font = .systemFont(ofSize: 12)
    descriptionLabel.textAlignment = .left
    descriptionLabel.numberOfLines = 2

    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
      descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
    ])
  }

  // Schedule Button
  private func configureScheduleButton() {
    addSubview(scheduleButton)
    views.append(scheduleButton)

    scheduleButton.tintColor = Zeplin.redBranding
    let title = "adicionar"
    let attributeString = NSMutableAttributedString(string: title)

    attributeString.addAttributes(
      [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
        NSAttributedString.Key.foregroundColor: Zeplin.redBranding
      ],
      range: NSRange(location: 0, length: title.utf8.count)
    )

    scheduleButton.setAttributedTitle(attributeString, for: .normal)
    scheduleButton.setImage(Icons.scheduleLive, for: .normal)
    scheduleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    scheduleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
    scheduleButton.contentHorizontalAlignment = .right

    scheduleButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      scheduleButton.heightAnchor.constraint(equalToConstant: 40),
      scheduleButton.widthAnchor.constraint(equalToConstant: 120),
      scheduleButton.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
      scheduleButton.bottomAnchor
        .constraint(equalTo: bottomAnchor, constant: -4)
    ])

    scheduleButton.addTarget(self, action: #selector(onButtonAction), for: .touchUpInside)
  }
}
