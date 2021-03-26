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
  func addNewOrders(_ orders: [YDOfflineOrdersOrder], loadMoreSectionIndex: Int?) {
//    if let loadMoreSectionIndex = loadMoreSectionIndex {
//      collectionView.reloadSections(IndexSet(integer: loadMoreSectionIndex))
//    }

    if orders.isEmpty { return }

    var indexes: [IndexPath] = []
    let totalSections = collectionView.numberOfSections - 1

    DispatchQueue.main.async { [weak self] in
      guard let self = self,
            let viewModel = self.viewModel
      else { return }

      for order in orders {
        guard let indexPath = order.indexPath else { continue }
        indexes.append(indexPath)
        if indexPath.section > totalSections {
          self.collectionView.insertSections(IndexSet(integer: indexPath.section))
        }
      }

      self.collectionView.insertItems(at: indexes)
      self.canLoadMore = !viewModel.noMoreOrderToLoad
      self.collectionView.collectionViewLayout.invalidateLayout()
      print("canLoadMore \(self.canLoadMore)")
      print("numberOfSections: \(self.collectionView.numberOfSections)")
      print("viewModel numberOfSections: \(self.viewModel?.numberOfSections())")
    }
  }
}

// MARK: Data Source
extension YDMOfflineOrdersViewController: UICollectionViewDataSource {
  // Number of Sections
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    if collectionView == shimmerCollectionView {
      return 1
    }

    return viewModel?.orderList.value.count ?? 0
  }

  // Number of Items
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == shimmerCollectionView {
      return numberOfShimmers ?? 1
    }

    if viewModel?[section]?.date == "loadMore" {
      return 0
    }

    return viewModel?[section]?.orders.count ?? 0
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

    // Cell
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: OrdersCollectionViewCell.identifier,
      for: indexPath
    ) as? OrdersCollectionViewCell,
    let order = viewModel?[indexPath.section]?.orders.at(indexPath.row)
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
            let nfe = order.nfe else { return }

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

  // Header / Footer
  public func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
      case UICollectionView.elementKindSectionHeader:
        guard let viewModel = viewModel else { fatalError("viewForSupplementaryElementOfKind: OrdersCollectionReusableView") }

        // From Load More
        if collectionView != shimmerCollectionView &&
            viewModel[indexPath.section]?.date == "loadMore" {
          guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: OrdersLoadingCollectionHeaderReusableView.identifier,
            for: indexPath
          ) as? OrdersLoadingCollectionHeaderReusableView
          else {
            fatalError("viewForSupplementaryElementOfKind: OrdersLoadingCollectionHeaderReusableView")
          }
          print("Dequeue Load More")
          return header
        }

        guard let header = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionHeader,
          withReuseIdentifier: OrdersCollectionReusableView.identifier,
          for: indexPath
        ) as? OrdersCollectionReusableView
        else {
          fatalError("viewForSupplementaryElementOfKind: OrdersCollectionReusableView")
        }

        print("Dequeue Data")

        if collectionView == shimmerCollectionView {
          header.dateLabel.text = ""
          return header
        }

        if let date = viewModel[indexPath.section]?.date {
          header.dateLabel.text = date
        } else {
          header.dateLabel.text = "--"
        }
        return header

      case UICollectionView.elementKindSectionFooter:
        guard let footer = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionFooter,
          withReuseIdentifier: OrdersCollectionFooterReusableView.identifier,
          for: indexPath
        ) as? OrdersCollectionFooterReusableView
        else {
          fatalError("viewForSupplementaryElementOfKind: OrdersCollectionFooterReusableView")
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
    if collectionView != shimmerCollectionView,
       viewModel?[indexPath.section]?.date == "loadMore",
        canLoadMore {
      canLoadMore = false

      if viewModel?.noMoreOrderToLoad ?? false {
        (view as? OrdersLoadingCollectionHeaderReusableView)?.fullSize = false
      } else {
        viewModel?.getMoreOrders()
      }
    }
  }
}

// MARK: Delegate
//extension YDMOfflineOrdersViewController: UICollectionViewDelegate {
//  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    let vc = OrderDetailsViewController()
//    vc.view.backgroundColor = view.backgroundColor
//    navigationController?.pushViewController(vc, animated: true)
//  }
//}

// MARK: Data Flow Delegate
extension YDMOfflineOrdersViewController: UICollectionViewDelegateFlowLayout {
  // Header Size
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    if collectionView != shimmerCollectionView &&
        viewModel?[section]?.date == "loadMore" {
      print("Header loadMore")
      return CGSize(width: view.frame.size.width, height: 255)
    }

    print("Header section \(section)")
    return section == 0 ?
      CGSize(width: view.frame.size.width, height: 40) :
      CGSize(width: view.frame.size.width, height: 30)
  }

  // Footer Size
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    guard let count = viewModel?.orderList.value.count else {
      return .zero
    }

    if collectionView != shimmerCollectionView &&
        viewModel?[section]?.date == "loadMore" {
      return .zero
    }

    return CGSize(width: view.frame.size.width, height: count - 1 == section ? 60 : 16)
  }
}
