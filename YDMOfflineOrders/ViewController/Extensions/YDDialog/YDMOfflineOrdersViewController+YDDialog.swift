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
    guard let nfe = payload?["nfe"] as? String else { return }
    print("nfe \(nfe)")
  }
}
