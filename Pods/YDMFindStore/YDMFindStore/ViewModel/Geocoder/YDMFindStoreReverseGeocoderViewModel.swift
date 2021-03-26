//
//  YDMFindStoreReverseGeocoderViewModel.swift
//  YDMFindStore
//
//  Created by Douglas Hennrich on 08/12/20.
//

import Foundation
import CoreLocation

import YDB2WModels

// MARK: Protocol
protocol YDMFindStoreReverseGeocoderDelegate: AnyObject {
  func getAddress(
    from location: CLLocationCoordinate2D,
    onCompletion: @escaping (Result<YDAddress, Error>) -> Void
  )
}

// MARK: Class
class YDMFindStoreReverseGeocoderViewModel {

  // MARK: Properties
  let service: YDMFindStoreReverseGeocoderServiceDelegate

  // MARK: Init
  init(service: YDMFindStoreReverseGeocoderServiceDelegate) {
    self.service = service
  }
}

// MARK: Extension
extension YDMFindStoreReverseGeocoderViewModel: YDMFindStoreReverseGeocoderDelegate {
  func getAddress(
    from location: CLLocationCoordinate2D,
    onCompletion: @escaping (Result<YDAddress, Error>) -> Void
  ) {

    service.getAddress(with: location) { result in
      switch result {
      case .success(let address):
        onCompletion(.success(address))

      case .failure(let error):
        onCompletion(.failure(error))
      }
    }
  }
}
