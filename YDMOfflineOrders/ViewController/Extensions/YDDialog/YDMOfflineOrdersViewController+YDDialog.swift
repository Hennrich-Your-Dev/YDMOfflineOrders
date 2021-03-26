//
//  YDMOfflineOrdersViewController+YDDialog.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 14/03/21.
//

import UIKit

import YDB2WComponents

extension YDMOfflineOrdersViewController: YDDialogCoordinatorDelegate {
  public func onActionYDDialog(payload: [String : Any]?) {
    guard let nfe = payload?["nfe"] as? String,
          let url = URL(string: nfe)
          else { return }
    UIApplication.shared.open(url)
  }

  public func onCancelYDDialog(payload: [String : Any]?) {}
}
