//
//  YDMFindStoreService.swift
//  YDMFindStore
//
//  Created by Douglas Hennrich on 09/12/20.
//

import Foundation
import CoreLocation

import YDB2WIntegration
import YDB2WModels
import YDUtilities

// MARK: Protocol
protocol YDMFindStoreServiceDelegate: AnyObject {
  func getNearstLasas(
    with location: CLLocationCoordinate2D,
    onCompletion: @escaping (Result<[YDStore], YDServiceError>) -> Void
  )
}

// MARK: Class
class YDMFindStoreService {

  // MARK: Properties
  let service: YDServiceClientDelegate
  let storesUrl: String

  // MARK: Init
  init(
    service: YDServiceClientDelegate,
    storesUrl url: String
  ) {
    self.service = service
    self.storesUrl = url
  }
}

// MARK: Extension
extension YDMFindStoreService: YDMFindStoreServiceDelegate {
  func getNearstLasas(
    with location: CLLocationCoordinate2D,
    onCompletion: @escaping (Result<[YDStore], YDServiceError>) -> Void
  ) {
    guard let config = YDIntegrationHelper.shared
            .getFeature(featureName: YDConfigKeys.store.rawValue),
          let extras = config.extras,
          var storesUrl = YDIntegrationHelper.shared
            .getFeature(featureName: YDConfigKeys.storeService.rawValue)?.endpoint,
          let radius = extras[YDConfigProperty.maxStoreRange.rawValue] as? Double
    else {
      fatalError("Can't get url extras")
    }

    let parameters: [String: Any] = [
      "latitude": location.latitude,
      "longitude": location.longitude,
      "type": "PICK_UP_IN_STORE",
      "radius": radius
    ]

    storesUrl += "/store"

    service.request(
      withUrl: storesUrl,
      withMethod: .get,
      andParameters: parameters) { (response: Result<YDStores, YDServiceError>) in
      switch response {
      case .success(let stores):
        let sorted = stores.stores.sorted {
          $0.distance ?? 0 < $1.distance ?? 0
        }

        onCompletion(.success(sorted))

      case .failure(let error):
        onCompletion(.failure(error))
      }
    }
  }
}
