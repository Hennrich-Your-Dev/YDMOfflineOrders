//
//  YDMOfflineOrdersViewController+CollectionView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 22/02/21.
//

import UIKit

import YDExtensions

// MARK: Data Source
extension YDMOfflineOrdersViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OrdersCollectionViewCell.identifier,
            for: indexPath) as? OrdersCollectionViewCell
    else { fatalError("Dequeue OrdersCollectionViewCell") }

    cell.widthAnchor.constraint(equalToConstant: collectionView.frame.size.width).isActive = true

    return cell
  }
}

// MARK: Delegate
extension YDMOfflineOrdersViewController: UICollectionViewDelegate {}
