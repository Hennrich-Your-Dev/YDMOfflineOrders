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
  func openDetailsForProduct(
    _ product: YDOfflineOrdersProduct,
    withinOrder order: YDOfflineOrdersOrder
  )
}

protocol OrderDetailsViewModelDelegate: AnyObject {
  var order: Binder<YDOfflineOrdersOrder> { get }
  var snackBar: Binder<(message: String, button: String?)> { get }

  func goBack()
  func openDetailsForProduct(_ product: YDOfflineOrdersProduct)
  func getProducts()
}

class OrderDetailsViewModel {
  // MARK: Properties
  let service: YDB2WServiceDelegate
  let navigation: OrderDetailsNavigation

  var order: Binder<YDOfflineOrdersOrder>
  var snackBar: Binder<(message: String, button: String?)> = Binder(("", nil))

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

  // Actions
  func useOfflineProducts() {
    guard let products = order.value.products else {
      return
    }

    for product in products {
      if product.products != nil { continue }

      let productForOnlineOffline = YDProduct(
        attributes: nil,
        description: nil,
        id: nil,
        ean: product.ean,
        images: nil,
        name: product.name,
        price: product.howMany == 1 ?
          product.totalPrice :
          (product.totalPrice / Double(product.howMany)),
        rating: nil,
        isAvailable: false
      )

      product.products = YDProductOnlineOffline(
        online: nil,
        offline: productForOnlineOffline
      )
    }

    self.order.fire()
  }
}

extension OrderDetailsViewModel: OrderDetailsViewModelDelegate {
  func goBack() {
    navigation.onBack()
  }

  func openDetailsForProduct(_ product: YDOfflineOrdersProduct) {
//    product.products?.online?.isAvailable = false

    if product.products?.online?.isAvailable == false {
      snackBar.value = ("Ops! O produto escolhido está indisponível no momento.", "ok, entendi")
      return
    }

    navigation.openDetailsForProduct(product, withinOrder: order.value)
  }

  func getProducts() {
    guard let products = order.value.products,
          let storeId = order.value.storeId
    else { return }

    let eans = products.compactMap { $0.ean }

    service.getProductsFromRESQL(
      eans: eans,
      storeId: "\(storeId)"
    ) { [weak self] (response: Result<YDProductsRESQL, YDB2WServices.YDServiceError>) in
      guard let self = self else { return }

      switch response {
        case .success(let restql):
          restql.products.enumerated().forEach { productsIndex, onlineOffline in
            if self.order.value.products?.at(productsIndex) != nil {
              self.order.value.products?[productsIndex].products = onlineOffline

              guard let totalPrice = self.order.value
                .products?[productsIndex].totalPrice,
                    let howMany = self.order.value
                      .products?[productsIndex].howMany
              else { return }

              self.order.value.products?[productsIndex]
                .products?.offline?.price = howMany == 1 ?
                totalPrice : (totalPrice / Double(howMany))
            }
          }
          self.order.fire()

        case .failure(let error):
          print(error.message)
          self.useOfflineProducts()
      }
    }
  }
}
