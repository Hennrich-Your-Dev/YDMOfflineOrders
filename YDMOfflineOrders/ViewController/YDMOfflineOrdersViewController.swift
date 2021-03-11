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
  public weak var delegate: YDMSOfflineOrdersDelegate?
  var viewModel: YDMOfflineOrdersViewModelDelegate?
  var navBarShadowOff = false
  var collectionView: UICollectionView!
  var shimmerCollectionView: UICollectionView!

  // MARK: Life cycle
  public override func viewDidLoad() {
    super.viewDidLoad()

    setUpLayout()
    setUpBinds()
    viewModel?.getOrderList()
  }
}

extension YDMOfflineOrdersViewController {
  func toggleNavShadow(_ show: Bool) {
    delegate?.toggleNavShadowYDMSO(show)
  }
}
