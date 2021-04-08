//
//  YDStoreAndProductView+UIState.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 07/04/21.
//

import UIKit

import YDUtilities

extension YDStoreAndProductView: UIStateDelegate {
  public func changeUIState(with type: UIStateEnum) {
    if type == .normal {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }

        self.textView.isHidden = false
        self.shimmerTextView.isHidden = true
        self.shimmerTextView.subviews.forEach { $0.stopShimmer() }
        self.storeNameAndAddressView.changeUIState(with: .normal)
        self.productCardView.changeUIState(with: .normal)
        self.updateLayoutWithProduct()
      }
      //
    } else if type == .loading {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }

        self.textView.isHidden = true
        self.shimmerTextView.isHidden = false
        self.shimmerTextView.subviews.forEach { $0.startShimmer() }
        self.storeNameAndAddressView.changeUIState(with: .loading)
        self.productCardView.changeUIState(with: .loading)
        self.segmentedControl.setEnabled(false, forSegmentAt: 0)
        self.segmentedControl.setEnabled(false, forSegmentAt: 1)
      }
    }
  }
}
