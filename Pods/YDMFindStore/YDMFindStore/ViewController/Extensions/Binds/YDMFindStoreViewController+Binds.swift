//
//  YDMFindStoreViewController+Binds.swift
//  YDMFindStore
//
//  Created by Douglas Hennrich on 10/12/20.
//

import UIKit
import CoreLocation

import YDUtilities
import YDExtensions

extension YDMFindStoreViewController {
  func setUpBinds() {

//    viewModel?.loading.bind { [weak self] isLoading in
//      isLoading ? self?.view.startLoader() : self?.view.stopLoader()
//    }

    viewModel?.location.bind { [weak self] location in
      self?.locationActivity(show: false)

      guard let self = self,
        let location = location
        else { return }

      if let coords = location.location {
        self.zoomToPosition(coords)
      }

      if let address = location.address,
        !address.isEmpty {
        self.locationButton.setTitle(address, for: .normal)
      }

      if let store = location.store,
         let latitude = store.geolocation?.latitude,
         let longitude = store.geolocation?.longitude {
        
        let userCoords = self.mapView.userLocation.coordinate
        let nearstStoreCoords = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        self.setMapCenterBetween(positionA: userCoords, positionB: nearstStoreCoords)
      }
    }

    viewModel?.stores.bind { [weak self] stores in
      self?.addPinsOnMap(with: stores)
      self?.collectionView.reloadData()
      self?.collectionView.scrollToItem(
        at: IndexPath(row: 0, section: 0),
        at: .centeredHorizontally,
        animated: true
      )
      self?.formatHowManyStoresOnList(with: stores.count)
    }
  }
}
