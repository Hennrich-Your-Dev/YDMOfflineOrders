//
//  YDDialogViewController.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 17/11/20.
//

import UIKit
import YDExtensions
import YDB2WAssets

public enum YDDialogType {
  case withIcon
  case withCancel
  case simple
}

class YDDialogViewController: UIViewController {
  // MARK: Properties
  var viewModel: YDDialogViewModelDelegate?
  var type: YDDialogType?
  var customIcon: UIImage?
  var customTitle: String?
  var customMessage: String?
  var customButton: String?
  var customCancelButton: String?
  var messageLink: [String: String]?

  // MARK: IBOutlets
  @IBOutlet weak var contentView: UIView! {
    didSet {
      contentView.layer.cornerRadius = 6
      contentView.layer.applyShadow(alpha: 0.08, blur: 20, spread: -1)
    }
  }

  @IBOutlet weak var icon: UIImageView! {
    didSet {
      icon.image = Icons.thumbDownWired
      icon.tintColor = UIColor.Zeplin.redBranding
    }
  }

  @IBOutlet weak var titleLabel: UILabel!

  @IBOutlet weak var descriptionLabel: UILabel!

  @IBOutlet weak var actionButton: YDWireButton! {
    didSet {
      actionButton.layer.cornerRadius = 4
      actionButton.layer.borderWidth = 1.5
      actionButton.layer.borderColor = UIColor.Zeplin.redBranding.cgColor
      actionButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      actionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
  }

  @IBOutlet weak var cancelButton: UIButton!

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    if let customIcon = customIcon {
      icon.image = customIcon
    }

    if let type = self.type {
      if type == .simple || type == .withCancel {
        icon.removeFromSuperview()
        view.layoutIfNeeded()
      }

      if type == .withCancel {
        cancelButton.isHidden = false
      }
    }

    if let customTitle = customTitle {
      titleLabel.text = customTitle
    }

    if let customMessage = customMessage {
      descriptionLabel.text = customMessage
    }

    if let customButton = customButton {
      actionButton.setTitle(customButton, for: .normal)
    }

    if let customCancelButton = customCancelButton {
      cancelButton.setTitle(customCancelButton, for: .normal)
      cancelButton.isHidden = false
    }

    if let messageLink = messageLink,
       let message = messageLink["message"],
       let link = messageLink["link"] {
      addMessageLink(message: message, link: link)
    }
  }

  // MARK: IBActions
  @IBAction func onAction(_ sender: UIButton) {
    viewModel?.onButtonAction()
  }

  @IBAction func onCancelAction(_ sender: UIButton) {
    viewModel?.onCancelAction()
  }

  // MARK: Actions
  func addMessageLink(message: String, link: String) {
    guard let fullMessage = descriptionLabel.text else { return }

    let attributedString = NSMutableAttributedString(string: fullMessage)

    let location = attributedString.mutableString.range(of: message).location
    let range = NSRange(location: location, length: message.count)

    attributedString.addAttribute(
      NSAttributedString.Key.underlineColor,
      value: Zeplin.redBranding,
      range: range
    )

    attributedString.addAttribute(
      NSAttributedString.Key.foregroundColor,
      value: Zeplin.redBranding,
      range: range
    )

    descriptionLabel.attributedText = attributedString

    let btn = UIButton()
    btn.addTarget(self, action: #selector(onLinkAction), for: .touchUpInside)
    view.addSubview(btn)

    btn.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      btn.topAnchor.constraint(equalTo: descriptionLabel.topAnchor),
      btn.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
      btn.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
      btn.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor)
    ])
  }

  @objc func onLinkAction() {
    guard let link = messageLink?["link"],
          let url = URL(string: link)
    else { return }

    UIApplication.shared.open(url)
  }
}
