//
//  YDWireButton.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 24/11/20.
//

import UIKit
import YDExtensions

public class YDWireButton: UIButton {
  // MARK: Properties
  public var callback: ((_ sender: UIButton) -> Void)?
  private var title = ""

  // MARK: Init
  public init(withTitle title: String) {
    super.init(frame: .zero)
    heightAnchor.constraint(equalToConstant: 40).isActive = true
    self.title = title

    setUpStyle()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.title = self.titleLabel?.text ?? ""
    setUpStyle()
  }

  // MARK: Actions
  public func setUpStyle() {
    layer.cornerRadius = 4
    layer.borderWidth = 1.5
    layer.borderColor = UIColor.Zeplin.redBranding.cgColor

    let attributedString = NSAttributedString(
      string: self.title,
      attributes: [
        NSAttributedString.Key.foregroundColor: UIColor.Zeplin.redBranding,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
      ]
    )

    setAttributedTitle(attributedString, for: .normal)

    addTarget(self, action: #selector(onButtonAction), for: .touchUpInside)
  }

  @objc func onButtonAction(_ sender: UIButton) {
    callback?(sender)
  }
}
