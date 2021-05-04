//
//  YDMFindStoreViewModel.swift
//  YDMFindStore
//
//  Created by Douglas Hennrich on 27/11/20.
//

import UIKit

import YDB2WIntegration
import YDUtilities
import YDExtensions
import YDB2WModels
import YDLocationModule
import YDB2WServices
import YDB2WDeepLinks

// MARK: Delegates
protocol YDMFindStoreNavigationDelegate {
  func onExit()
}

protocol YDMFindStoreViewModelDelegate {
  var location: Binder<YDLocationViewModel?> { get }
  var stores: Binder<[YDStore]> { get }

  func trackMetric()
  func getPreviousAddress()
  subscript(_ index: Int) -> YDStore? { get }

  // Buttons actions
  func onExit()
  func onGetLocation()
  func onGetCurrentLocation()
  func onStoreCardAction(type: OnStoreCardActionEnum, store: YDStore)
}

// MARK: View Model
class YDMFindStoreViewModel {
  // MARK: Properties
  lazy var logger = Logger.forClass(Self.self)
  let navigation: YDMFindStoreNavigationDelegate
  let service: YDB2WServiceDelegate

  var location: Binder<YDLocationViewModel?> = Binder(nil)
  var stores: Binder<[YDStore]> = Binder([])

  private let locationManager = YDLocation.shared
  private var alreadyGetUsersPosition = false

  // MARK: Init
  init(
    navigation: YDMFindStoreNavigationDelegate,
    service: YDB2WServiceDelegate = YDB2WService()
  ) {
    self.navigation = navigation
    self.service = service
  }
}

// MARK: Extension delegate
extension YDMFindStoreViewModel: YDMFindStoreViewModelDelegate {

  subscript(_ index: Int) -> YDStore? {
    return stores.value.at(index)
  }

  func trackMetric() {
    YDIntegrationHelper.shared.trackEvent(withName: .findStoreView, ofType: .state)
  }

  func getPreviousAddress() {
    YDIntegrationHelper.shared.getAddress { [weak self] currentAddress in
      guard let self = self else { return }
      guard let address = currentAddress,
            let coordinates = address.coords
      else {
        self.onGetLocation()
        return
      }

      self.searchForNewStore(
        with: coordinates,
        givingAddress: address.formatAddress,
        givingType: address.type
      )
    }
  }

  func onExit() {
    navigation.onExit()
  }

  func onGetLocation() {
    locationManager.delegate = nil
    locationManager.delegate = self

    guard location.value?.address != nil,
          alreadyGetUsersPosition
    else {
      locationManager.start()
      alreadyGetUsersPosition = true
      return
    }

    callAddressModuleFromB2W()
  }

  func onGetCurrentLocation() {
    locationManager.delegate = nil
    locationManager.delegate = self

    locationManager.start()
  }

  func onStoreCardAction(type: OnStoreCardActionEnum, store: YDStore) {
    switch type {
    case .product:
      let parameters: [String: String] = [
        "sellerId": store.sellerID ?? "",
        "storeId": store.sellerStoreID ?? ""
      ]

      guard let urlString = queryString(YDDeepLinks.lasaStore.rawValue, params: parameters),
            let url = URL(string: urlString),
            !url.absoluteString.isEmpty else {
        return
      }

      UIApplication.shared.open(url, options: [:], completionHandler: nil)

    case .whatsapp: break
    }
  }
}
