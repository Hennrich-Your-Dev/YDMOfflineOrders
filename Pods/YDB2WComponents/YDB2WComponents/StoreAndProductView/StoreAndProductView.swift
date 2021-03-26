//
//  StoreAndProductView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 25/03/21.
//

import UIKit

import YDExtensions
import YDB2WModels

// MARK: Delegate
public protocol YDStoreAndProductDelegate: AnyObject {
  func onChangeStoreAction()
  func didMove(direction: YDStoreAndProductView.ScrollDirection)
}

// MARK: View
public class YDStoreAndProductView: UIView {
  // MARK: Enum
  public enum ScrollDirection {
    case up
    case down
  }

  // MARK: Properties
  public var product: YDProduct? {
    didSet {
      updateLayoutWithProduct()
    }
  }
  public var store: YDStore? {
    didSet {
      updateLayoutWithStore()
    }
  }
  public weak var delegate: YDStoreAndProductDelegate?
  var lastContentOffset: CGFloat = 0

  // MARK: Components
  let storeNameAndAddressView = YDStoreNameAddressView(withButton: true)
  let separatorView = UIView()
  let productCardView = YDProductCardView()
  let segmentedControl = YDSegmentedControl()
  let textView = UITextView()
  let tableView = UITableView()

  // MARK: Init
  public init() {
    super.init(frame: .zero)

    backgroundColor = UIColor.Zeplin.white
    layer.applyShadow(x: 0, y: 0, blur: 20)
    layer.cornerRadius = 8

    setUpLayouts()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  private func updateLayoutWithProduct() {
    guard let product = self.product else { return }
    productCardView.product = product

    let description = product.getHtmlDescription()
    let technicalInformation = product.getTechnicalInformation()

    if description == nil {
      segmentedControl.setEnabled(false, forSegmentAt: 0)
    } else {
      segmentedControl.selectedSegmentIndex = 0
      changeSegmentControl(0)
    }

    if technicalInformation.isEmpty {
      segmentedControl.setEnabled(false, forSegmentAt: 1)
    }
  }

  private func updateLayoutWithStore() {
    guard let store = self.store else { return }

    storeNameAndAddressView.changeValues(
      storeName: store.name,
      storeAddress: store.formatAddress
    )
  }
}
