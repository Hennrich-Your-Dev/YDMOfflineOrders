//
//  YDMOfflineOrdersViewController+CollectionView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 22/02/21.
//

import UIKit

import YDExtensions
import YDB2WComponents
import YDB2WModels

// MARK: Actions
extension YDMOfflineOrdersViewController {
  func addNewOrders() {
//    if orders.isEmpty { return }
//
//    var indexes: [IndexPath] = []
//    let totalSections = collectionView.numberOfSections - 1

    DispatchQueue.main.async { [weak self] in
      guard let self = self,
            let viewModel = self.viewModel,
            !viewModel.noMoreOrderToLoad
      else { return }

      self.collectionView.reloadSections([0])
      self.canLoadMore = !viewModel.noMoreOrderToLoad
      // self.collectionView.collectionViewLayout.invalidateLayout()
      print("canLoadMore \(self.canLoadMore)")
    }
  }

  func dequeueCell(at indexPath: IndexPath) -> UICollectionViewCell {
    guard let config = viewModel?[indexPath.row] else { fatalError("dequeueCell") }

    switch config.type {
      case .header:
        return dequeueHeader(at: indexPath, withConfig: config)
      case .row:
        return dequeueOrderCell(at: indexPath, withOrder: config.order)
    }
  }

  // Header cell
  func dequeueHeader(
    at indexPath: IndexPath,
    withConfig config: OrderListConfig
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: OrdersHeaderCollectionViewCell.identifier,
      for: indexPath
    ) as? OrdersHeaderCollectionViewCell
    else { fatalError("Dequeue OrdersCollectionViewCell") }

    cell.dateLabel.text = config.headerString

    return cell
  }

  // Order cell
  func dequeueOrderCell(
    at indexPath: IndexPath,
    withOrder order: YDOfflineOrdersOrder?
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: OrdersCollectionViewCell.identifier,
      for: indexPath
    ) as? OrdersCollectionViewCell,
    let order = order
    else { fatalError("Dequeue OrdersCollectionViewCell") }

    cell.config(with: order)

    cell.productCallback = { [weak self] product in
      guard let self = self else { return }
      self.viewModel?.openDetailsForProduct(product)
    }

    cell.orderDetailsCallback = { [weak self] in
      guard let self = self else { return }
      self.viewModel?.openDetailsForOrder(order)
    }

    cell.noteCallback = { [weak self] in
      guard let self = self,
            let nfe = order.strippedNFe else { return }

      let dialog = YDDialog()
      dialog.delegate = self
      dialog.payload = ["nfe": nfe]
      dialog.start(
        ofType: .withCancel,
        customTitle: "atenção",
        customMessage: "acesse e confira através do site da nota fiscal eletrônica.",
        customButton: "ver nota fiscal",
        customCancelButton: "depois vejo"
      )
    }

    return cell
  }
}

// MARK: Data Source
extension YDMOfflineOrdersViewController: UICollectionViewDataSource {
  // Number of Items
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == shimmerCollectionView {
      return numberOfShimmers ?? 1
    }

    return viewModel?.orderList.value.count ?? 0
  }

  // Dequeue Item
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // Dequeue Shimmer
    if collectionView == shimmerCollectionView {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: OrdersShimmerCollectionViewCell.identifier,
        for: indexPath
      ) as? OrdersShimmerCollectionViewCell
      else {
        fatalError("Dequeue OrdersShimmerCollectionViewCell")
      }

      cell.startShimmerForCell()
      return cell
    }

    return dequeueCell(at: indexPath)
  }

  // Header / Footer
  public func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
      case UICollectionView.elementKindSectionHeader:
        fatalError("There's no Header")

      case UICollectionView.elementKindSectionFooter:
        guard let footer = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionFooter,
          withReuseIdentifier: OrdersLoadingCollectionFooterReusableView.identifier,
          for: indexPath
        ) as? OrdersLoadingCollectionFooterReusableView
        else {
          fatalError("viewForSupplementaryElementOfKind: OrdersLoadingCollectionFooterReusableView")
        }

        return footer

      default:
        fatalError("viewForSupplementaryElementOfKind")
    }
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    willDisplaySupplementaryView view: UICollectionReusableView,
    forElementKind elementKind: String,
    at indexPath: IndexPath
  ) {
//    if collectionView != shimmerCollectionView,
//       viewModel?[indexPath.section]?.date == "loadMore",
//        canLoadMore {
//      canLoadMore = false
//
//      if viewModel?.noMoreOrderToLoad ?? false {
//        (view as? OrdersLoadingCollectionHeaderReusableView)?.fullSize = false
//      } else {
//        viewModel?.getMoreOrders()
//      }
//    }
  }
}

// MARK: Data Flow Delegate
extension YDMOfflineOrdersViewController: UICollectionViewDelegateFlowLayout {
  // Footer Size
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    return CGSize(width: view.frame.size.width, height: 235)
  }
}
