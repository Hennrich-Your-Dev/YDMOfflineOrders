//
//  YDMOfflineOrdersViewController+YDDialog.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 14/03/21.
//

import UIKit

import YDB2WComponents
import YDB2WIntegration

extension YDMOfflineOrdersViewController: YDDialogCoordinatorDelegate {
  public func onActionYDDialog(payload: [String: Any]?) {
    guard let nfe = payload?["nfe"] as? String,
          let url = URL(string: "https://www.nfe.fazenda.gov.br/portal/consultaRecaptcha.aspx?nfe=" + nfe)
          else { return }

    YDIntegrationHelper.shared
      .trackEvent(
        withName: .offlineOrders,
        ofType: .action,
        withParameters: [
          "&ea=": "clique-botao",
          "&el=": "Botão ver nota fiscal"
        ]
      )

    UIApplication.shared.open(url)
  }

  public func onCancelYDDialog(payload: [String: Any]?) {}
}
