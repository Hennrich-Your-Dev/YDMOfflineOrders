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
import YDMFindStore

protocol OfflineOrdersNavigationDelegate: AnyObject {
  func setNavigationController(_ navigation: UINavigationController?)
  func openDetailsForProduct(
    _ product: YDOfflineOrdersProduct,
    withinOrder order: YDOfflineOrdersOrder
  )
  func openDetailsForOrder(_ order: YDOfflineOrdersOrder)
}

protocol YDMOfflineOrdersViewModelDelegate: AnyObject {
  var error: Binder<String> { get }
  var loading: Binder<Bool> { get }
  var snackBar: Binder<(message: String, button: String?)> { get }
  var hasPreviousAddressFromIntegration: Bool { get }
  var orderListFirstRequest: Binder<Bool> { get }
  var orderList: Binder<[OrderListConfig]> { get }
  var newOrdersForList: Binder<Bool> { get }
  var noMoreOrderToLoad: Bool { get }
  var loadMoreError: Binder<String?> { get }

  subscript(_ item: Int) -> OrderListConfig? { get }

  func setNavigationController(_ navigation: UINavigationController?)

  func login()
  func getMoreOrders()

  func openNote(withKey key: String?)
  func openDetailsForProduct(
    _ product: YDOfflineOrdersProduct,
    withinOrder order: YDOfflineOrdersOrder
  )
  func openDetailsForOrder(_ order: YDOfflineOrdersOrder)
  func onFeedbackButton()
  func getProductsForOrder(
    at index: Int,
    onCompletion completion: @escaping (Bool) -> Void
  )
}

class YDMOfflineOrdersViewModel {
  // MARK: Properties
  lazy var logger = YDUtilities.Logger.forClass(Self.self)
  let service: YDB2WServiceDelegate
  let navigation: OfflineOrdersNavigationDelegate
  var hasPreviousAddressFromIntegration = YDIntegrationHelper.shared.currentAddres != nil

  var error: Binder<String> = Binder("")
  var loading: Binder<Bool> = Binder(false)
  var snackBar: Binder<(message: String, button: String?)> = Binder(("", nil))

  var orderListFirstRequest: Binder<Bool> = Binder(false)
  var orderList: Binder<[OrderListConfig]> = Binder([])
  var newOrdersForList: Binder<Bool> = Binder(false)
  var loadMoreError: Binder<String?> = Binder(nil)
  var noMoreOrderToLoad = false
  let lazyLoadingOrders: Int
  var currentPage = 1

  let currentUser: YDCurrentCustomer
  var userToken = ""

  // MARK: Init
  init(
    navigation: OfflineOrdersNavigationDelegate,
    service: YDB2WServiceDelegate = YDB2WService(),
    currentUser: YDCurrentCustomer,
    lazyLoadingOrders: Int
  ) {
    self.navigation = navigation
    self.service = service
    self.currentUser = currentUser
    self.lazyLoadingOrders = lazyLoadingOrders

    trackEvent(withName: .offlineOrders, ofType: .state)
  }

  // MARK: Actions
  func trackEvent(
    withName name: TrackEvents,
    ofType type: TrackType,
    withParameters params: [String: Any]? = nil
  ) {
    YDIntegrationHelper.shared
      .trackEvent(
        withName: name,
        ofType: type,
        withParameters: params
      )
  }

  private func sortOrdersList(
    _ orders: [YDOfflineOrdersOrder]
  ) -> [YDOfflineOrdersOrder] {
    let sorted = orders.sorted { lhs, rhs -> Bool in
      guard let dateLhs = lhs.dateWithDateType else { return false }
      guard let dateRhs = rhs.dateWithDateType else { return true }

      return dateLhs.compare(dateRhs) == .orderedDescending
    }

    return sorted
  }

  private func addOrdersToList(_ sorted: [YDOfflineOrdersOrder], append: Bool) {
    if sorted.isEmpty {
      noMoreOrderToLoad = true
      newOrdersForList.value = false

      if !append {
        orderListFirstRequest.value = true
      }
    } else {
      for curr in sorted {
        guard let sectionDate = curr.formattedDateSection else { continue }

        if let lastIndex = orderList.value.lastIndex(
          where: { $0.type == .row && $0.headerString == sectionDate }
        ) {
          curr.indexPath = IndexPath(item: lastIndex + 1, section: 0)
          let newOrder = OrderListConfig(
            type: .row,
            headerString: sectionDate,
            order: curr
          )

          orderList.value.append(newOrder)

          //
        } else {
          let newHeader = OrderListConfig(
            type: .header,
            headerString: sectionDate,
            order: nil
          )
          orderList.value.append(newHeader)

          curr.indexPath = IndexPath(
            item: orderList.value.count,
            section: 0
          )

          let newOrder = OrderListConfig(
            type: .row,
            headerString: sectionDate,
            order: curr
          )

          orderList.value.append(newOrder)
        }
      }

      if append {
        newOrdersForList.value = true
      } else {
        orderListFirstRequest.value = true
      }
    }
  }

  func openDeepLink(withName name: YDDeepLinks) {
    guard let url = URL(string: name.rawValue),
          !url.absoluteString.isEmpty
    else { return }

    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}

// MARK: Extension
extension YDMOfflineOrdersViewModel: YDMOfflineOrdersViewModelDelegate {
  subscript(_ item: Int) -> OrderListConfig? {
    return orderList.value.at(item)
  }

  func setNavigationController(_ navigation: UINavigationController?) {
    self.navigation.setNavigationController(navigation)
  }

  func login() {
    loading.value = true

    service.getLasaClientLogin(
      user: currentUser,
      socialSecurity: nil
    ) { [weak self] (response: Result<YDLasaClientLogin, YDServiceError>) in
      guard let self = self else { return }

      switch response {
        case .success(let userLoginData):
          self.userToken = userLoginData.token ?? ""
          self.getOrderList()

        case .failure(let error):
          self.error.value = error.message
          self.logger.error(error.message)
      }
    }
  }

  func getOrderList() {
    loading.value = true

    // Mock
//    fromMock()
//    return;

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

    // From mock
//    getMoreOrdersFromMock()
//    return;

    service.offlineOrdersGetOrders(
      userToken: userToken,
      page: currentPage,
      limit: lazyLoadingOrders
    ) { [weak self] (result: Result<YDOfflineOrdersOrdersList, YDB2WServices.YDServiceError>) in
      guard let self = self else { return }

      switch result {
        case .success(let orders):
          let sorted = self.sortOrdersList(orders)
          self.addOrdersToList(sorted, append: true)


        case .failure(let error):
          self.logger.error(error.message)
          self.currentPage -= 1
          self.loadMoreError.value = "Ops! Falha ao carregar mais compras realizadas nas lojas físicas."
      }
    }
  }

  func openNote(withKey key: String?) {}

  func openDetailsForProduct(
    _ product: YDOfflineOrdersProduct,
    withinOrder order: YDOfflineOrdersOrder
  ) {
//    product.products?.online?.isAvailable = false

    if product.products?.online?.isAvailable == false {
      snackBar.value = ("Ops! O produto escolhido está indisponível no momento.", "ok, entendi")
      return
    }

    navigation.openDetailsForProduct(product, withinOrder: order)
  }

  func openDetailsForOrder(_ order: YDOfflineOrdersOrder) {
    navigation.openDetailsForOrder(order)
  }

  func onFeedbackButton() {
    if hasPreviousAddressFromIntegration {
      openDeepLink(withName: .lasaStore)
    } else {
      YDMFindStore().start()
    }
  }

  func getProductsForOrder(
    at index: Int,
    onCompletion completion: @escaping (Bool) -> Void
  ) {
    guard let order = orderList.value.at(index)?.order,
          order.alreadySearchOnAPI == false,
          let products = order.products,
          let storeId = order.storeId
    else {
      completion(false)
      return
    }

    orderList.value[index].order?.alreadySearchOnAPI = true

    let eans = Array(products.map { $0.ean }.compactMap { $0 }.prefix(3))

    service.getProductsFromRESQL(
      eans: eans,
      storeId: "\(storeId)"
    ) { [weak self] (response: Result<YDProductsRESQL, YDB2WServices.YDServiceError>) in
      guard let self = self else { return }

      switch response {
        case .success(let restql):
          restql.products.enumerated().forEach { productsIndex, onlineOffline in
            if self.orderList.value.at(index) != nil {
              self.orderList.value[index].order?
                .products?[productsIndex].products = onlineOffline

              guard let totalPrice = self.orderList.value.at(index)?
                      .order?.products?[productsIndex].totalPrice,
                    let howMany = self.orderList.value.at(index)?
                      .order?.products?[productsIndex].howMany
              else { return }

              self.orderList.value[index].order?
                .products?[productsIndex].products?
                .offline?.price = howMany == 1 ?
                totalPrice : (totalPrice / Double(howMany))
            }
          }
          completion(true)

        case .failure:
          completion(true)
      }
    }
  }
}

// MARK: Mock
extension YDMOfflineOrdersViewModel {
  // MARK: Actions
  private func fromMock() {
    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
      guard let self = self else { return }
      let orders = YDOfflineOrdersOrder.mock()
      //      let sorted = self.sortOrdersList([])
      let sorted = self.sortOrdersList(orders)
      self.addOrdersToList(sorted, append: false)
      self.loading.value = false
      //      self.error.value = "a"
    }
  }

  private func getMoreOrdersFromMock() {
    if currentPage == 2 {
      loadMoreError.value = "Ops! Falha ao carregar mais compras realizadas nas lojas físicas."
      currentPage = 1
      return
    }

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
        "valorTotal": 999999,
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
            "item": "ADICIONADO",
            "qtde": 1,
            "valorTotalItem": 999999
          },
        ]
      },
      {
        "cupom": 1,
        "chaveNfe": "NFe21201233014556116658653060000071951662105676",
        "data": "2020-12-10T00:00:00",
        "valorTotal": 999999,
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
            "item": "ADICIONADO",
            "qtde": 1,
            "valorTotalItem": 999999
          },
        ]
      },
      {
        "cupom": 1,
        "chaveNfe": "NFe21201233014556116658653060000071951662105676",
        "data": "2020-11-10T00:00:00",
        "valorTotal": 999999,
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
            "item": "ADICIONADO",
            "qtde": 1,
            "valorTotalItem": 999999
          },
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
}
