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
  var hasButton = true
  public var callback: (() -> Void)?
  var shimmers: [UIView] = []

  // MARK: Componentes
  let container = UIView()
  let storeNameLabel = UILabel()
  let storeAddressLabel = UILabel()
  let actionButton = UIButton()

  let shimmerContainer = UIView()
  let shimmerNameLabel = UIView()
  let shimmerAddressLabel = UIView()
  let shimmerActionButton = UILabel()

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
  @objc func onButtonAction() {
    callback?()
  }

  // MARK: Public actions
  public func changeValues(storeName: String?, storeAddress: String?) {
    storeNameLabel.text = storeName
    storeAddressLabel.text = storeAddress
  }
}
