//
//  OrderDetailsViewController+Binds.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 06/04/21.
//

import UIKit

extension OrderDetailsViewController {
  func setUpBinds() {
    viewModel?.order.bind { [weak self] _ in
      guard let self = self else { return }
      self.collectionView.reloadData()
    }
  }
}
