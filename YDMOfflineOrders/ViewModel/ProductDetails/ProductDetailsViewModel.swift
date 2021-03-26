//
//  ProductDetailsViewModel.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 26/03/21.
//

import Foundation

import YDUtilities
import YDExtensions
import YDB2WIntegration
import YDB2WModels

protocol ProductDetailsViewModelDelegate: AnyObject {
  var currentAddress: Binder<YDAddress?> { get }
  var currentStore: Binder<YDStore?> { get }
  var currentProductOnlineOffline: Binder<YDProductOnlineOffline?> { get }

  func changeAddress()
}

class ProductDetailsViewModel {
  // MARK: Properties
  var currentAddress: Binder<YDAddress?> = Binder(nil)
  var currentStore: Binder<YDStore?> = Binder(nil)
  var currentProductOnlineOffline: Binder<YDProductOnlineOffline?> = Binder(nil)
}

extension ProductDetailsViewModel: ProductDetailsViewModelDelegate {
  func changeAddress() {
    YDIntegrationHelper.shared.onAddressModule { address in
      guard let address = address else { return }
      print("address: \(address.formatAddress)")
    }
  }
}
