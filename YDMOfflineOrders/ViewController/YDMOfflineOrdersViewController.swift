//
//  YDMOfflineOrdersViewController.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 21/02/21.
//

import UIKit

public protocol YDMSOfflineOrdersDelegate: AnyObject {
  func toggleNavShadowYDMSO(_ show: Bool)
}

public class YDMOfflineOrdersViewController: UIViewController {
  // MARK: Properties
  weak var delegate: YDMSOfflineOrdersDelegate?
  var navBarShadowOff = false
  var collectionView: UICollectionView!

  // MARK: Life cycle
  public override func viewDidLoad() {
    super.viewDidLoad()

    setUpLayout()
  }
}

extension YDMOfflineOrdersViewController {
  func toggleNavShadow(_ show: Bool) {
    delegate?.toggleNavShadowYDMSO(show)
  }
}
