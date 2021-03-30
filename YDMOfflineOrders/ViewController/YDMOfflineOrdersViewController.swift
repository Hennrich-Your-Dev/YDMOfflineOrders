//
//  YDMOfflineOrdersViewController.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 21/02/21.
//

import UIKit

public class YDMOfflineOrdersViewController: UIViewController {
  // MARK: Enum
  enum FeedbackStateViewType {
    case empty
    case error
  }

  // MARK: Properties
  var viewModel: YDMOfflineOrdersViewModelDelegate?
  var alreadyBindNavigation = false
  var navBarShadowOff = false
  var numberOfShimmers: Int?
  var canLoadMore = true

  var feedbackMessageEmpty = "Ops! Você ainda não possui um histórico de compras realizadas em nossas lojas físicas."
  var feedbackMessageError = "Ops! Falha ao carregar."
  var feedbackStateType: FeedbackStateViewType = .empty {
    didSet {
      // Icon
      feedbackStateIcon.isHidden = feedbackStateType == .error

      // Message
      feedbackMessage.text = feedbackStateType == .empty ? feedbackMessageEmpty : feedbackMessageError

      // Button
      let attributedString = NSAttributedString(
        string: feedbackStateType == .empty ? "ver loja mais próxima" : "atualizar",
        attributes: [
          NSAttributedString.Key.foregroundColor: UIColor.Zeplin.redBranding,
          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ]
      )
      feedbackStateButton.setAttributedTitle(attributedString, for: .normal)

      feedbackStateButtonWidthConstraint?.constant = feedbackStateType == .empty ? 175 : 86
      feedbackStateView.setNeedsLayout()
    }
  }

  // Components
  var collectionView: UICollectionView!
  var shimmerCollectionView: UICollectionView!
  var shadowView = UIView()
  var feedbackStateView = UIView()
  var feedbackStateIcon = UIImageView()
  var feedbackMessage = UILabel()
  var feedbackStateButton = UIButton()
  var feedbackStateButtonWidthConstraint: NSLayoutConstraint?

  // MARK: Life cycle
  public override func viewDidLoad() {
    super.viewDidLoad()

    setUpLayout()
    setUpBinds()
    viewModel?.getOrderList()
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if !alreadyBindNavigation {
      alreadyBindNavigation = true
      viewModel?.setNavigationController(navigationController)
    }
  }
}

// MARK: Actions
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

  func showFeedbackStateView(ofType type: FeedbackStateViewType) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      self.shadowView.isHidden = true
      self.collectionView.isHidden = true
      self.shimmerCollectionView.isHidden = true
      self.shimmerCollectionView.contentOffset = .zero
      self.feedbackStateView.isHidden = false
      self.feedbackStateType = type
      self.feedbackStateButton.isHidden = false
    }
  }

  @objc func onFeedbackButtonAction() {
    if feedbackStateType == .empty {
      viewModel?.onFeedbackButton()
    } else {
      viewModel?.getOrderList()
    }
  }
}
