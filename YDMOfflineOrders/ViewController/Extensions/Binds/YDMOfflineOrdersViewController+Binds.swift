//
//  YDMOfflineOrdersViewController+Binds.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 10/03/21.
//

import UIKit

extension YDMOfflineOrdersViewController {
  func setUpBinds() {
    viewModel?.orderList.bind { [weak self] _ in
      self?.collectionView.reloadData()
    }

    viewModel?.loading.bind { [weak self] isLoading in
      if isLoading {
        self?.shimmerCollectionView.reloadData()
      } else {
        self?.shimmerCollectionView.removeFromSuperview()
        self?.collectionView.isHidden = false
      }
    }
  }
}
