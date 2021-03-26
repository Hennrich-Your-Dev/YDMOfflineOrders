//
//  YDMFindStoreReverseGeocoderService.swift
//  YDMFindStore
//
//  Created by Douglas Hennrich on 09/12/20.
//

import Foundation
import CoreLocation

import YDB2WModels
import YDUtilities

// MARK: Protocol
protocol YDMFindStoreReverseGeocoderServiceDelegate: AnyObject {
  func getAddress(
    with location: CLLocationCoordinate2D,
    onCompletion: @escaping (Result<YDAddress, YDServiceError>) -> Void
  )
}

// MARK: Class
class YDMFindStoreReverseGeocoderService {

  // MARK: Properties
  let service: YDServiceClientDelegate
  let reverseGeocodeUrl: String

  // MARK: Init
  init(
    service: YDServiceClientDelegate,
    reverseGeocodeUrl url: String
  ) {
    self.service = service
    self.reverseGeocodeUrl = url
  }
}

// MARK: Extension
extension YDMFindStoreReverseGeocoderService: YDMFindStoreReverseGeocoderServiceDelegate {
  func getAddress(
    with location: CLLocationCoordinate2D,
    onCompletion: @escaping (Result<YDAddress, YDServiceError>) -> Void
  ) {

    let parameters = [
      "latitude":  location.latitude,
      "longitude": location.longitude
    ]

    service.request(
      withUrl: reverseGeocodeUrl,
      withMethod: .get,
      andParameters: parameters
    ) { (response: Result<[YDAddress], YDServiceError>) in
      switch response {
      case .success(let addresses):
        if let address = addresses.first {
          onCompletion(.success(address))
        } else {
          onCompletion(.failure(YDServiceError.notFound))
        }

      case .failure(let error):
        onCompletion(.failure(error))
      }
    }
  }
}
