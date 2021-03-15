//
//  YDMOfflineOrdersCoordinator.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 21/02/21.
//

import UIKit

import YDB2WIntegration
import YDB2WModels

public typealias YDMOfflineOrders = YDMOfflineOrdersCoordinator

public class YDMOfflineOrdersCoordinator {
  var navigationController: UINavigationController?

  public init() {}

  public func start(userToken: String, navController: UINavigationController?) {
    let vc = YDMOfflineOrdersViewController()
    let viewModel = YDMOfflineOrdersViewModel(navigation: self, userToken: userToken)
    vc.viewModel = viewModel
    navController?.pushViewController(vc, animated: true)
    navigationController = navController
  }

  public func start(userToken: String) -> YDMOfflineOrdersViewController {
    let vc = YDMOfflineOrdersViewController()
    let viewModel = YDMOfflineOrdersViewModel(navigation: self, userToken: userToken)
    vc.viewModel = viewModel
    return vc
  }

  // MARK: Actions
  func onBack() {
    if navigationController?.viewControllers.count == 1 {
      navigationController?.dismiss(animated: true, completion: nil)
    } else {
      navigationController?.popViewController(animated: true)
    }
  }

  func openDetailsForProduct(_ product: YDOfflineOrdersProduct) {
    let vc = ProductDetailsViewController()
    navigationController?.pushViewController(vc, animated: true)
  }

  func openNote(withKey key: String) {

  }
}

// MARK: Orders Navigation
extension YDMOfflineOrdersCoordinator: OfflineOrdersNavigationDelegate {
  func setNavigationController(_ navigation: UINavigationController?) {
    self.navigationController = navigation
  }

  func openDetailsForOrder(_ order: YDOfflineOrdersOrder) {
    let vc = OrderDetailsViewController()
    let viewModel = OrderDetailsViewModel(navigation: self, order: order)
    vc.viewModel = viewModel
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: Order Details Navigation
extension YDMOfflineOrdersCoordinator: OrderDetailsNavigation {}
