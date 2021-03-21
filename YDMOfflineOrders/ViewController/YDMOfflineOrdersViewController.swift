//
//  YDMOfflineOrdersViewController.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 21/02/21.
//

import UIKit

public class YDMOfflineOrdersViewController: UIViewController {
  // MARK: Properties
  var viewModel: YDMOfflineOrdersViewModelDelegate?
  var alreadyBindNavigation = false
  var navBarShadowOff = false
  var collectionView: UICollectionView!
  var shadowView = UIView()
  var shimmerCollectionView: UICollectionView!

  // MARK: Life cycle
  public override func viewDidLoad() {
    super.viewDidLoad()

    setUpLayout()
    setUpBinds()
    viewModel?.getOrderList()
  }

  public override func viewWillAppear(_ animated: Bool) {
    if !alreadyBindNavigation {
      alreadyBindNavigation = true
      viewModel?.setNavigationController(navigationController)
    }
  }
}

extension YDMOfflineOrdersViewController {
  func toggleNavShadow(_ show: Bool) {
    DispatchQueue.main.async {
      if show {
        UIView.animate(withDuration: 0.5) { [weak self] in
          guard let self = self else { return }
          self.shadowView.layer.applyShadow()
        }
      } else {
        UIView.animate(withDuration: 0.5) { [weak self] in
          guard let self = self else { return }
          self.shadowView.layer.shadowOpacity = 0
        }
      }
    }
  }
}
