//
//  OrderDetailsViewController+YDDialog.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 14/03/21.
//

import Foundation

import YDB2WComponents

extension OrderDetailsViewController: YDDialogCoordinatorDelegate {
  public func onActionYDDialog(payload: [String: Any]?) {
    guard let nfe = payload?["nfe"] as? String else { return }
    print("nfe \(nfe)")
  }

  public func onCancelYDDialog(payload: [String: Any]?) {}
}
