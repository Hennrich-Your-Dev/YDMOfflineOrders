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
  var orderList: Binder<[[String: YDOfflineOrdersOrdersList]]> { get }
  var hasPreviousAddressFromIntegration: Bool { get }

  subscript(section: Int) -> YDOfflineOrdersOrdersList? { get }

  func setNavigationController(_ navigation: UINavigationController?)
  func getOrderList()
  func getMoreOrders()
  func numberOfSections() -> Int
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
  var orderList: Binder<[[String: YDOfflineOrdersOrdersList]]> = Binder([])
  var orders: [[String: YDOfflineOrdersOrdersList]] = []
  var userToken: String
  var hasPreviousAddressFromIntegration = YDIntegrationHelper.shared.currentAddres != nil
  let lazyLoadingOrders: Int
  var currentPage = 0

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

        if let index = orders.firstIndex(where: { $0.keys.first == sectionDate }),
           var arr = orders.at(index) {
          //
          arr[sectionDate]?.append(order)
          orders[index] = arr
        } else {
          orders.append([sectionDate: [order]])
        }
      }

      orderList.value = orders

    } else {
      if !append {
        orders = []
        orderList.value = []
      }
    }
  }
}

// MARK: Extension
extension YDMOfflineOrdersViewModel: YDMOfflineOrdersViewModelDelegate {
  subscript(section: Int) -> YDOfflineOrdersOrdersList? {
    return orderList.value.at(section)?.values.first
  }

  func setNavigationController(_ navigation: UINavigationController?) {
    self.navigation.setNavigationController(navigation)
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
