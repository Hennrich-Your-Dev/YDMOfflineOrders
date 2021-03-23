//
//  YDMOfflineOrdersViewModel.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 21/02/21.
//

import UIKit

import YDUtilities
import YDExtensions
import YDB2WServices
import YDB2WModels
import YDB2WIntegration
import YDB2WDeepLinks

protocol OfflineOrdersNavigationDelegate: AnyObject {
  func setNavigationController(_ navigation: UINavigationController?)
  func openDetailsForProduct(_ product: YDOfflineOrdersProduct)
  func openDetailsForOrder(_ order: YDOfflineOrdersOrder)
}

protocol YDMOfflineOrdersViewModelDelegate: AnyObject {
  var error: Binder<String> { get }
  var loading: Binder<Bool> { get }
  var orderList: Binder<[OrderListConfig]> { get }
  var newOrdersForList: Binder<[YDOfflineOrdersOrder]> { get }
  var hasPreviousAddressFromIntegration: Bool { get }
  var noMoreOrderToLoad: Bool { get }

  subscript(section: Int) -> OrderListConfig? { get }

  func setNavigationController(_ navigation: UINavigationController?)

  func getAllOrdersConfigs() -> [OrderListConfig]
  func numberOfSections() -> Int
  func getOrderList()
  func getMoreOrders()

  func openNote(withKey key: String?)
  func openDetailsForProduct(_ product: YDOfflineOrdersProduct)
  func openDetailsForOrder(_ order: YDOfflineOrdersOrder)
  func openDeepLink(withName name: YDDeepLinks)
}

class YDMOfflineOrdersViewModel {
  // MARK: Properties
  lazy var logger = YDUtilities.Logger.forClass(Self.self)
  let service: YDB2WServiceDelegate = YDB2WService()
  let navigation: OfflineOrdersNavigationDelegate

  var error: Binder<String> = Binder("")
  var loading: Binder<Bool> = Binder(false)
  var orderList: Binder<[OrderListConfig]> = Binder([])
  var newOrdersForList: Binder<[YDOfflineOrdersOrder]> = Binder([])
  var orders: [OrderListConfig] = []
  var userToken: String
  var hasPreviousAddressFromIntegration = YDIntegrationHelper.shared.currentAddres != nil
  let lazyLoadingOrders: Int
  var currentPage = 0
  var noMoreOrderToLoad = false

  // MARK: Init
  init(
    navigation: OfflineOrdersNavigationDelegate,
    userToken: String,
    lazyLoadingOrders: Int
  ) {
    self.navigation = navigation
    self.userToken = userToken
    self.lazyLoadingOrders = lazyLoadingOrders
  }

  // MARK: Actions
  private func fromMock() {
    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
      guard let self = self else { return }
      let sorted = self.sortOrdersList(YDOfflineOrdersOrder.mock())
      self.addOrdersToList(sorted, append: false)
      self.loading.value = false
    }
  }

  private func sortOrdersList(_ orders: YDOfflineOrdersOrdersList) -> [YDOfflineOrdersOrder] {
    let sorted = orders.sorted { lhs, rhs -> Bool in
      guard let dateLhs = lhs.dateWithDateType else { return false }
      guard let dateRhs = rhs.dateWithDateType else { return true }

      return dateLhs.compare(dateRhs) == .orderedDescending
    }

    return sorted
  }

  private func addOrdersToList(_ sorted: [YDOfflineOrdersOrder], append: Bool) {
    if !sorted.isEmpty {
      for order in sorted {
        guard let sectionDate = order.formatedDateSection else { continue }

        if let index = orders.firstIndex(where: { $0.date == sectionDate }),
           let config = orders.at(index) {
          //
          var ordersCopy = config.orders
          order.indexPath = IndexPath(row: ordersCopy.count - 1, section: config.section ?? 0)
          ordersCopy.append(order)
          orders[index].orders = ordersCopy
        } else {
          order.indexPath = IndexPath(row: 0, section: orders.count - 1)
          orders.append(
            OrderListConfig(
              date: sectionDate,
              section: orders.count - 1,
              orders: [order]
            )
          )
        }
      }

      orders.append(
        OrderListConfig(
          date: "loadMore",
          section: orders.count - 1,
          orders: []
        )
      )
      orderList.value = orders
      newOrdersForList.value = sorted


    } else {
      noMoreOrderToLoad = true
      newOrdersForList.value = []
    }
  }
}

// MARK: Extension
extension YDMOfflineOrdersViewModel: YDMOfflineOrdersViewModelDelegate {
  subscript(section: Int) -> OrderListConfig? {
    return orders.first(where: { $0.section == section })
  }

  func setNavigationController(_ navigation: UINavigationController?) {
    self.navigation.setNavigationController(navigation)
  }

  func getAllOrdersConfigs() -> [OrderListConfig] {
    return orders
  }

  func getOrderList() {
    loading.value = true

    // Mock
    fromMock()
    return;

    service.offlineOrdersGetOrders(
      userToken: userToken,
      page: currentPage,
      limit: lazyLoadingOrders
    ) { [weak self] (result: Result<YDOfflineOrdersOrdersList, YDB2WServices.YDServiceError>) in
      guard let self = self else { return }

      self.loading.value = false

      switch result {
        case .success(let orders):
          let sorted = self.sortOrdersList(orders)
          self.addOrdersToList(sorted, append: false)

        case .failure(let error):
          self.error.value = error.message
          self.logger.error(error.message)
      }
    }
  }

  func getMoreOrders() {
    currentPage += 1
    _ = orders.popLast()

    if currentPage >= 3 {
      addOrdersToList([], append: true)
      return
    }

    let jsonString = """
    [
      {
        "cupom": 1,
        "chaveNfe": "NFe21201233014556116658653060000071951662105676",
        "data": "2020-12-10T00:00:00",
        "valorTotal": 2093,
        "codigoLoja": 1230,
        "nomeLoja": "PINHEIRO",
        "logradouro": "PRACA JOSE SARNEY S N",
        "cep": "65200-000",
        "cidade": "PINHEIRO",
        "uf": "MA",
        "itens": [
          {
            "codigoItem": 1,
            "ean": "7891356075599",
            "item": "0",
            "qtde": 1,
            "valorTotalItem": 299
          },
          {
            "codigoItem": 1,
            "ean": "7891356075599",
            "item": "9999",
            "qtde": 1,
            "valorTotalItem": 299
          },
          {
            "codigoItem": 1,
            "ean": "7891356075599",
            "item": "0",
            "qtde": 1,
            "valorTotalItem": 299
          },
          {
            "codigoItem": 1,
            "ean": "7891356075599",
            "item": "9999",
            "qtde": 1,
            "valorTotalItem": 299
          },
          {
            "codigoItem": 1,
            "ean": "7891356075599",
            "item": "0",
            "qtde": 1,
            "valorTotalItem": 299
          },
          {
            "codigoItem": 1,
            "ean": "7891356075599",
            "item": "0",
            "qtde": 1,
            "valorTotalItem": 299
          },
          {
            "codigoItem": 1,
            "ean": "7891356075599",
            "item": "9999",
            "qtde": 1,
            "valorTotalItem": 299
          }
        ]
      }
    ]
    """

    guard let data = jsonString.data(using: .utf8),
          let parsed = try? JSONDecoder().decode(YDOfflineOrdersOrdersList.self, from: data)
    else {
      return
    }

    let sorted = sortOrdersList(parsed)
    addOrdersToList(sorted, append: true)
  }

  func numberOfSections() -> Int {
    return orders.count
  }

  func openNote(withKey key: String?) {}

  func openDetailsForProduct(_ product: YDOfflineOrdersProduct) {
    navigation.openDetailsForProduct(product)
  }

  func openDetailsForOrder(_ order: YDOfflineOrdersOrder) {
    navigation.openDetailsForOrder(order)
  }

  func openDeepLink(withName name: YDDeepLinks) {
    guard let url = URL(string: name.rawValue),
          !url.absoluteString.isEmpty
    else { return }

    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
