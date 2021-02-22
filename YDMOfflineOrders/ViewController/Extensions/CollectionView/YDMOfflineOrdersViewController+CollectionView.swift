//
//  YDMOfflineOrdersViewController+CollectionView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 22/02/21.
//

import UIKit

// MARK: Data Source
extension YDMOfflineOrdersViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return UICollectionViewCell()
  }
}

// MARK: Delegate
extension YDMOfflineOrdersViewController: UICollectionViewDelegate {

}
