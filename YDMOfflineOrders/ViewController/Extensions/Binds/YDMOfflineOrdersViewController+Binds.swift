//
//  YDMOfflineOrdersViewController+Binds.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 10/03/21.
//

import UIKit

extension YDMOfflineOrdersViewController {
  func setUpBinds() {
    viewModel?.orderList.bindOnce { [weak self] list in
      guard let self = self else { return }

      if !list.isEmpty {
        self.collectionView.reloadData()
      } else {
        self.showFeedbackStateView(ofType: .empty)
      }
    }

    viewModel?.newOrdersForList.bind { [weak self] newOrders in
      guard let self = self else { return }
      self.addNewOrders(newOrders)
    }

    viewModel?.loading.bind { [weak self] isLoading in
      guard let self = self else { return }

      if isLoading {
        self.shimmerCollectionView.isHidden = false
        self.shimmerCollectionView.reloadData()
        self.feedbackStateView.isHidden = true
      } else {
        self.shimmerCollectionView.isHidden = true
        self.collectionView.isHidden = false
      }
    }

    viewModel?.error.bind { [weak self] _ in
      guard let self = self else { return }
      self.showFeedbackStateView(ofType: .error)
    }
  }
}
