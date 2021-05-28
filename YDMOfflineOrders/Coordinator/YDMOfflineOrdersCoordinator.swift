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

  let currentUser: YDCurrentCustomer
  private var lazyLoadingOrders: Int = 5

  public init() {
    if let limit = YDIntegrationHelper.shared
        .getFeature(featureName: YDConfigKeys.lasaClientService.rawValue)?
        .extras?[YDConfigProperty.lazyLoadingOrders.rawValue] as? Int {
      self.lazyLoadingOrders = limit
    }

    guard let user = YDIntegrationHelper.shared.currentUser else {
      fatalError("Não existe um usuário logado")
    }

    self.currentUser = user
  }

  public func start(navController: UINavigationController?) {
    let vc = YDMOfflineOrdersViewController()
    let viewModel = YDMOfflineOrdersViewModel(
      navigation: self,
      currentUser: currentUser,
      lazyLoadingOrders: self.lazyLoadingOrders
    )
    vc.viewModel = viewModel
    navController?.pushViewController(vc, animated: true)
    navigationController = navController
  }

  public func start() -> YDMOfflineOrdersViewController {
    let vc = YDMOfflineOrdersViewController()
    let viewModel = YDMOfflineOrdersViewModel(
      navigation: self,
      currentUser: currentUser,
      lazyLoadingOrders: self.lazyLoadingOrders
    )
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

  func openDetailsForProduct(
    _ product: YDOfflineOrdersProduct,
    withinOrder order: YDOfflineOrdersOrder
  ) {
    let vc = ProductDetailsViewController()

    let viewModel = ProductDetailsViewModel(product: product.products, order: order)
    vc.viewModel = viewModel

    navigationController?.pushViewController(vc, animated: true)
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
