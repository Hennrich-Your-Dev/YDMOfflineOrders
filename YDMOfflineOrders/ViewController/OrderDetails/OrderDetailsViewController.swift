//
//  OrderDetailsViewController.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 12/03/21.
//

import UIKit

class OrderDetailsViewController: UIViewController {
  // MARK: Properties
  var viewModel: OrderDetailsViewModelDelegate?

  var separatorView = UIView()
  var collectionView: UICollectionView!
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
    
  }
}
