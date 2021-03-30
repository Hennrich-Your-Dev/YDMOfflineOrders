//
//  YDMOfflineOrdersViewController+Binds.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 10/03/21.
//

import UIKit

import YDUtilities

extension YDMOfflineOrdersViewController {
  func setUpBinds() {
    viewModel?.orderListFirstRequest.bindOnce { [weak self] _ in
      guard let self = self,
            let orderList = self.viewModel?.orderList.value
      else { return }

      if !orderList.isEmpty {
        self.collectionView.reloadData()
      } else {
        self.showFeedbackStateView(ofType: .empty)
      }
    }

    viewModel?.newOrdersForList.bind { [weak self] hasMore in
      guard let self = self else { return }
      if hasMore {
        self.addNewOrders()
      }
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
