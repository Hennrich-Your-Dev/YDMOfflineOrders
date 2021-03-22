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
  var orders: YDOfflineOrdersOrdersList = []
  var userToken: String
  var hasPreviousAddressFromIntegration = YDIntegrationHelper.shared.currentAddres != nil

  // MARK: Init
  init(
    navigation: OfflineOrdersNavigationDelegate,
    userToken: String
  ) {
    self.navigation = navigation
    self.userToken = userToken
  }

  // MARK: Actions
  private func fromMock() {
    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
      guard let self = self else { return }
      self.orders = [] // YDOfflineOrdersOrder.mock()
      self.sortOrdersList()
      self.loading.value = false
//      self.error.value = "true"
    }
  }

  private func sortOrdersList() {
    let sorted = orders.sorted { lhs, rhs -> Bool in
      guard let dateLhs = lhs.dateWithDateType else { return false }
      guard let dateRhs = rhs.dateWithDateType else { return true }

      return dateLhs.compare(dateRhs) == .orderedDescending
    }

    if !sorted.isEmpty {
      for order in sorted {
        guard let sectionDate = order.formatedDateSection else { continue }

        if let index = orderList.value.firstIndex(where: { $0.keys.first == sectionDate }),
           var arr = orderList.value.at(index) {
          //
          arr[sectionDate]?.append(order)
          orderList.value[index] = arr
        } else {
          orderList.value.append([sectionDate: [order]])
        }
      }
    } else {
      orderList.value = []
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
      page: 1,
      limit: 20
    ) { [weak self] (result: Result<YDOfflineOrdersOrdersList, YDB2WServices.YDServiceError>) in
      self?.loading.value = false

      switch result {
        case .success(let orders):
          self?.orders = orders
          self?.sortOrdersList()

        case .failure(let error):
          self?.error.value = error.message
          self?.logger.error(error.message)
      }
    }
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
