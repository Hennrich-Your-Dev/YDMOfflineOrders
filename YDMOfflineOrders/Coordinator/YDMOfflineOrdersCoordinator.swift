//
//  YDMOfflineOrdersCoordinator.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 21/02/21.
//

import UIKit

import YDB2WIntegration

public typealias YDMOfflineOrders = YDMOfflineOrdersCoordinator

public class YDMOfflineOrdersCoordinator {
  var navigationController: UINavigationController?

  public init() {}

  public func start(userToken: String, navController: UINavigationController?) {
    let vc = YDMOfflineOrdersViewController()
    let viewModel = YDMOfflineOrdersViewModel(userToken: userToken)
    vc.viewModel = viewModel
    navController?.pushViewController(vc, animated: true)
  }

  public func start(userToken: String) -> YDMOfflineOrdersViewController {
    let vc = YDMOfflineOrdersViewController()
    let viewModel = YDMOfflineOrdersViewModel(userToken: userToken)
    vc.viewModel = viewModel
    return vc
  }
}
