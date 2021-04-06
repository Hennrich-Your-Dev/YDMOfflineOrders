//
//  OrderDetailsViewModel.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 12/03/21.
//

import Foundation

import YDB2WServices
import YDExtensions
import YDB2WModels
import YDUtilities

protocol OrderDetailsNavigation {
  func onBack()
  func openDetailsForProduct(_ product: YDOfflineOrdersProduct)
}

protocol OrderDetailsViewModelDelegate: AnyObject {
  var order: Binder<YDOfflineOrdersOrder> { get }

  func goBack()
  func openDetailsForProduct(_ product: YDOfflineOrdersProduct)
  func getProjects()
}

class OrderDetailsViewModel {
  // MARK: Properties
  let service: YDB2WServiceDelegate
  let navigation: OrderDetailsNavigation
  var order: Binder<YDOfflineOrdersOrder>

  // MARK: Init
  init(
    service: YDB2WServiceDelegate = YDB2WService(),
    navigation: OrderDetailsNavigation,
    order: YDOfflineOrdersOrder
  ) {
    self.service = service
    self.navigation = navigation
    self.order = Binder(order)
  }
}

extension OrderDetailsViewModel: OrderDetailsViewModelDelegate {
  func goBack() {
    navigation.onBack()
  }

  func openDetailsForProduct(_ product: YDOfflineOrdersProduct) {
    navigation.openDetailsForProduct(product)
  }

  func getProjects() {
    guard let products = order.value.products,
          let storeId = order.value.storeId
    else { return }

    let eans = products.dropFirst(3).map { $0.ean }.compactMap { $0 }

    service.getProductsFromRESQL(
      eans: eans,
      storeId: "\(storeId)"
    ) { [weak self] (response: Result<YDProductsRESQL, YDB2WServices.YDServiceError>) in
      guard let self = self else { return }

      switch response {
        case .success(let restql):
          restql.products.enumerated().forEach { productsIndex, onlineOffline in
            self.order.value.products?[3 + productsIndex].products = onlineOffline
          }
          self.order.fire()

        case .failure(let error):
          print(error.message)
      }
    }
  }
}
