//
//  YDWireButton.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 24/11/20.
//

import UIKit
import YDExtensions

public protocol YDWireButtonDelegate {
  func onActionYDWireButton(_ button: UIButton)
}

public class YDWireButton: UIButton {
  // MARK: Properties
  public var delegate: YDWireButtonDelegate?

  // MARK: Init
  public init() {
    let rect = CGRect(x: 0, y: 0, width: 200, height: 50)
    super.init(frame: rect)
    setUpStyle()
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setUpStyle()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setUpStyle()
  }

  // MARK: Actions
  public func setUpStyle() {
    layer.cornerRadius = 8
    layer.borderWidth = 1
    layer.borderColor = UIColor.Zeplin.redBranding.cgColor
    setTitleColor(UIColor.Zeplin.redBranding, for: .normal)

    if let title = titleLabel?.text {
      let attributedString = NSAttributedString(
        string: title,
        attributes: [
          NSAttributedString.Key.foregroundColor: UIColor.Zeplin.redBranding,
          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)
        ]
      )

      setAttributedTitle(attributedString, for: .normal)
    }

    addTarget(self, action: #selector(onButtonAction), for: .touchUpInside)
  }

  @objc func onButtonAction(_ sender: UIButton) {
    delegate?.onActionYDWireButton(sender)
  }
}
