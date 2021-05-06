//
//  OrderDetailsViewController+Binds.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 06/04/21.
//

import UIKit

import YDB2WComponents

extension OrderDetailsViewController {
  func setUpBinds() {
    viewModel?.order.bind { [weak self] _ in
      guard let self = self else { return }
      self.collectionView.reloadData()
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
