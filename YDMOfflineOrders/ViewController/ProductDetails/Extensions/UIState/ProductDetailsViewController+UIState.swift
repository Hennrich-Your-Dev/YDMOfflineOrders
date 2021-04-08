//
//  ProductDetailsViewController+UIState.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 08/04/21.
//

import UIKit

import YDUtilities

extension ProductDetailsViewController: UIStateDelegate {
  func changeUIState(with type: UIStateEnum) {
    switch type {
      case .normal:
        storeAndProductView.changeUIState(with: .normal)
        onlineProductView.changeUIState(with: .normal)

      case .loading:
        storeAndProductView.changeUIState(with: .loading)
        onlineProductView.changeUIState(with: .loading)

      default:
        break
    }
  }
}
