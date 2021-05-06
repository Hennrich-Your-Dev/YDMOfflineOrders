//
//  YDMOfflineOrdersViewController+Binds.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 10/03/21.
//

import UIKit

import YDUtilities
import YDB2WComponents

extension YDMOfflineOrdersViewController {
  func setUpBinds() {
    viewModel?.orderListFirstRequest.bindOnce { [weak self] _ in
      guard let self = self,
            let orderList = self.viewModel?.orderList.value
      else { return }

      if !orderList.isEmpty {
        DispatchQueue.main.async {
          self.collectionView.reloadData()
          Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
            self.canLoadMore = true
          }
        }
      } else {
        self.showFeedbackStateView(ofType: .empty)
      }
    }

    viewModel?.newOrdersForList.bind { [weak self] hasMore in
      guard let self = self else { return }
      print("newOrdersForList \(hasMore)")
      print("canLoadMore", self.canLoadMore)
      if hasMore {
        self.addNewOrders()
      } else {
        self.loadMoreShimmer?.stopShimmerAndHide()
        self.collectionView.collectionViewLayout.invalidateLayout()
      }
    }

    viewModel?.loading.bind { [weak self] isLoading in
      guard let self = self else { return }

      DispatchQueue.main.async {
        if isLoading {
          self.shimmerCollectionView.isHidden = false
          self.shimmerCollectionView.reloadData()
          self.feedbackStateView.isHidden = true
        } else {
          self.shimmerCollectionView.isHidden = true
          self.collectionView.isHidden = false
        }
      }
    }

    viewModel?.error.bind { [weak self] _ in
      guard let self = self else { return }
      self.showFeedbackStateView(ofType: .error)
    }

    viewModel?.loadMoreError.bind { [weak self] message in
      guard let self = self,
            let message = message
      else { return }

      let snackBar = YDSnackBarView(parent: self.view)
      snackBar.delegate = self
      snackBar.showMessage(message, ofType: .withButton(buttonName: "atualizar"))

      self.collectionView.scrollToItem(
        at: IndexPath(
          item: self.collectionView.numberOfItems(inSection: 0) - 1,
          section: 0
        ),
        at: .bottom,
        animated: true
      )

      Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
        self.canLoadMore = true
      }
    }

    viewModel?.snackBar.bind { [weak self] params in
      guard let self = self else { return }

      let snack = YDSnackBarView(parent: self.view)

      if let buttonTitle = params.button {
        snack.showMessage(params.message, ofType: .withButton(buttonName: buttonTitle))
      } else {
        snack.showMessage(params.message, ofType: .simple)
      }
    }
  }
}
