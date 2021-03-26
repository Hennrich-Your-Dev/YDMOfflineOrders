//
//  StoreAndProductView+ScrollView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 26/03/21.
//

import UIKit

extension YDStoreAndProductView: UITextViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y.rounded()

    if lastContentOffset > offset {
      lastContentOffset = offset
      delegate?.didMove(direction: .down)

      //
    } else if lastContentOffset < offset {
      lastContentOffset = offset
      delegate?.didMove(direction: .up)
    }
  }
}
