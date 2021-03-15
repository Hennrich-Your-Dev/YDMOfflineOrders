//
//  OrderDetailsViewController.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 12/03/21.
//

import UIKit

import YDB2WComponents

class OrderDetailsViewController: UIViewController {
  // MARK: Properties
  var viewModel: OrderDetailsViewModelDelegate?

  var separatorView = UIView()
  var collectionView: UICollectionView!
  var navBarShadowOff = false
  var shadowTop = UIView()
  var shadowBottom = UIView()
  var noteButton = UIButton()
  var priceLabel = UILabel()

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLayout()
  }

  // MARK: Actions
  @objc func onBackAction(_ sender: UIButton) {
    viewModel?.goBack()
  }

  @objc func onNoteAction(_ sender: UIButton) {
    guard let nfe = viewModel?.order.nfe else { return }

    let dialog = YDDialog()
    dialog.delegate = self
    dialog.payload = ["nfe": nfe]
    dialog.start(
      ofType: .withCancel,
      customTitle: "atenção",
      customMessage: "Acesse e confira através do site da nota fiscal eletrônica.",
      customButton: "ver nota fiscal",
      customCancelButton: "depois vejo"
    )
  }

  func toggleNavShadow(_ show: Bool) {
    DispatchQueue.main.async {
      if show {
        UIView.animate(withDuration: 0.5) { [weak self] in
          guard let self = self else { return }
          self.shadowTop.layer.applyShadow()
          self.separatorView.isHidden = true
        }
      } else {
        UIView.animate(withDuration: 0.5) { [weak self] in
          guard let self = self else { return }
          self.shadowTop.layer.shadowOpacity = 0
          self.separatorView.isHidden = false
        }
      }
    }
  }
}
