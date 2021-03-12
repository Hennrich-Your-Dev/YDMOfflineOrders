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

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLayout()
  }

  // MARK: Actions
  @objc func onBackAction(_ sender: UIButton) {
    viewModel?.goBack()
  }
}
