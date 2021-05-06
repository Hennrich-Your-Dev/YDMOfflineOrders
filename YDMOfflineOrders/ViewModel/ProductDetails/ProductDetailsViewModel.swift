//
//  ProductDetailsViewModel.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 26/03/21.
//

import Foundation
import CoreLocation

import YDUtilities
import YDExtensions
import YDB2WIntegration
import YDB2WModels
import YDB2WServices

protocol ProductDetailsViewModelDelegate: AnyObject {
  var error: Binder<Bool> { get }
  var loading: Binder<Bool> { get }
  var currentStore: Binder<YDStore?> { get }
  var currentProductOnlineOffline: Binder<YDProductOnlineOffline?> { get }

  func changeAddress()
}

class ProductDetailsViewModel {
  // MARK: Properties
  let service: YDB2WServiceDelegate = YDB2WService()
  var order: YDOfflineOrdersOrder
  var error: Binder<Bool> = Binder(false)
  var loading: Binder<Bool> = Binder(false)
  var currentStore: Binder<YDStore?> = Binder(nil)
  var currentProductOnlineOffline: Binder<YDProductOnlineOffline?> = Binder(nil)

  // MARK: Init
  init(product: YDProductOnlineOffline?, order: YDOfflineOrdersOrder) {
    self.order = order
    currentProductOnlineOffline.value = product

    let address = YDAddress(
      postalCode: order.addressZipcode,
      address: order.addressStreet,
      city: order.addressCity,
      state: order.addressState
    )

    currentStore.value = YDStore(
      id: "\(order.storeId ?? 0)",
      name: order.formattedStoreName,
      address: address
    )
  }
}

// MARK: Actions
extension ProductDetailsViewModel {
  func getNewStoreAndProducts(with location: CLLocationCoordinate2D) {
    DispatchQueue.global(qos: .utility).async { [weak self] in
      guard let self = self else { return }
      self.loading.value = true

      let queueGroup = DispatchGroup()
      queueGroup.enter()

      self.searchForNewStore(with: location) { [weak self] store in
        guard let self = self else { return }

        if let store = store {
          self.currentStore.value = store
        }
        queueGroup.leave()
      }

      queueGroup.wait()
      self.getNewProducts()
    }
  }

  func searchForNewStore(
    with location: CLLocationCoordinate2D,
    onCompletion completion: @escaping (YDStore?) -> Void
  ) {
    service
      .getNearstLasa(with: location) { (response: Result<YDStores, YDB2WServices.YDServiceError>) in
        switch response {
          case .success(let stores):
            let sorted = stores.stores.prefix(10).compactMap { $0 }.sorted {
              $0.distance ?? 100000 < $1.distance ?? 100000
            }

            completion(sorted.first)

          case .failure(let error):
            print(#function, error.message)
            completion(nil)
        }
    }
  }

  func getNewProducts() {
    guard let storeId = currentStore.value?.sellerStoreID,
          let ean = currentProductOnlineOffline.value?.ean
    else {
      loading.value = false
      return
    }

    service.getProductsFromRESQL(
      eans: [ean],
      storeId: storeId
    ) { [weak self] (response: Result<YDProductsRESQL, YDB2WServices.YDServiceError>) in
      guard let self = self else { return }
      self.loading.value = false

      switch response {
        case .success(let result):
          // For testing
          // self.error.fire()
          // return;

          guard let first = result.products.first else {
            self.error.fire()
            return
          }

          first.online = self.currentProductOnlineOffline.value?.online

          // For Testing
          // first.offline?.isAvailable = false

          self.currentProductOnlineOffline.value = first

        case .failure(let error):
          print(#function, error.message)
          self.error.fire()
      }
    }
  }
}

// MARK: Delegate
extension ProductDetailsViewModel: ProductDetailsViewModelDelegate {
  func changeAddress() {
    YDIntegrationHelper.shared.onAddressModule { [weak self] address in
      guard let self = self,
            let address = address,
            let coords = address.coords
      else { return }

      self.getNewStoreAndProducts(with: coords)
    }
  }
}
