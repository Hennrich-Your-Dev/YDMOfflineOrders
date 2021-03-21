//
//  YDMOfflineOrdersViewController+CollectionView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 22/02/21.
//

import UIKit

import YDExtensions
import YDB2WComponents

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

    return viewModel?[section]?.count ?? 0
  }

  // Dequeue Item
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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

    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: OrdersCollectionViewCell.identifier,
      for: indexPath
    ) as? OrdersCollectionViewCell,
    let order = viewModel?[indexPath.section]?.at(indexPath.row)
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
        guard let header = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionHeader,
          withReuseIdentifier: OrdersCollectionReusableView.identifier,
          for: indexPath
        ) as? OrdersCollectionReusableView
        else {
          fatalError("viewForSupplementaryElementOfKind: OrdersCollectionReusableView")
        }

        if collectionView == shimmerCollectionView {
          header.dateLabel.text = ""
          return header
        }

        if let date = viewModel?[indexPath.section]?.first?.formatedDateSection {
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
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return section == 0 ?
      CGSize(width: view.frame.size.width, height: 40) :
      CGSize(width: view.frame.size.width, height: 30)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    guard let count = viewModel?.orderList.value.count else {
      return .zero
    }

    return CGSize(width: view.frame.size.width, height: count - 1 == section ? 60 : 16)
  }
}
