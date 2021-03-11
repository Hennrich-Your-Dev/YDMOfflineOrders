//
//  YDMOfflineOrdersCoordinator.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 21/02/21.
//

import UIKit

public typealias YDMOfflineOrders = YDMOfflineOrdersCoordinator

public class YDMOfflineOrdersCoordinator {
  var navigationController: UINavigationController?

  public init() {}

  public func start(navController: UINavigationController?) {
    let vc = YDMOfflineOrdersViewController()
    vc.viewModel = YDMOfflineOrdersViewModel()
    navController?.pushViewController(vc, animated: true)
  }

  public func start() -> YDMOfflineOrdersViewController {
    let vc = YDMOfflineOrdersViewController()
    vc.viewModel = YDMOfflineOrdersViewModel()
    return vc
  }
}
