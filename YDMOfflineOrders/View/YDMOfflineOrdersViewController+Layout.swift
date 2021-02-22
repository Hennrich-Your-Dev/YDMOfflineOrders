//
//  YDMOfflineOrdersViewController+Layout.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 22/02/21.
//

import UIKit

extension YDMOfflineOrdersViewController {
  func setUpLayout() {
    createCollectionView()
  }

  func createCollectionView() {
    let layoutFlow = UICollectionViewFlowLayout()
    layoutFlow.sectionInset = UIEdgeInsets(top: view.safeAreaInsets.top + 20,
                                           left: 0,
                                           bottom: view.safeAreaInsets.bottom + 20,
                                           right: 0)

    layoutFlow.estimatedItemSize = CGSize(width: view.frame.size.width, height: 177)
    layoutFlow.scrollDirection = .vertical
    layoutFlow.minimumLineSpacing = 16

    collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layoutFlow)

    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .clear

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    collectionView.register(OrdersCollectionViewCell.self,
                            forCellWithReuseIdentifier: OrdersCollectionViewCell.identifier)
  }
}
