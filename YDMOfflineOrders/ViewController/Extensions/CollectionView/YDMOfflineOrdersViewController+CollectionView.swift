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
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }

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

  public func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
      case UICollectionView.elementKindSectionHeader:
        guard let header = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionHeader,
          withReuseIdentifier: OrdersCollectionReusableView.identifier,
          for: indexPath
        ) as? OrdersCollectionReusableView
        else {
          fatalError("viewForSupplementaryElementOfKind: OrdersCollectionReusableView")
        }

        return header

      default:
        fatalError("viewForSupplementaryElementOfKind")
    }
  }
}

// MARK: Delegate
extension YDMOfflineOrdersViewController: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = OrderDetailsViewController()
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: Data Flow Delegate
extension YDMOfflineOrdersViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return section == 0 ?
      CGSize(width: view.frame.size.width, height: 40) :
      CGSize(width: view.frame.size.width, height: 30)
  }
}
