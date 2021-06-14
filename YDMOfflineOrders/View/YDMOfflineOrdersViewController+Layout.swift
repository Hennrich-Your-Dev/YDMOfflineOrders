//
//  YDMOfflineOrdersViewController+Layout.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 22/02/21.
//
import UIKit

import YDExtensions
import YDB2WAssets

extension YDMOfflineOrdersViewController {
  func setUpLayout() {
    createCollectionView()
    createShimmerCollectionView()
    createShadowView()
    createFeedbackStateView()
  }

  func createCollectionView() {
    let layoutFlow = UICollectionViewFlowLayout()
    layoutFlow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    layoutFlow.scrollDirection = .vertical
    layoutFlow.estimatedItemSize = CGSize(width: view.frame.size.width, height: 235)
    layoutFlow.minimumLineSpacing = 16

    collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layoutFlow)
    collectionView.isHidden = true

    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .clear
    collectionView.alwaysBounceVertical = true

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 8
      ),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    // Order cell
    collectionView.register(
      OrdersCollectionViewCell.self,
      forCellWithReuseIdentifier: OrdersCollectionViewCell.identifier
    )

    // Header cell
    collectionView.register(
      OrdersHeaderCollectionViewCell.self,
      forCellWithReuseIdentifier: OrdersHeaderCollectionViewCell.identifier
    )

    // Header section
    collectionView.register(
      OrdersCollectionFooterReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: OrdersCollectionFooterReusableView.identifier
    )

    // Loading footer
    collectionView.register(
      OrdersLoadingCollectionFooterReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: OrdersLoadingCollectionFooterReusableView.identifier
    )
  }

  func createShadowView() {
    shadowView.backgroundColor = .white
    view.addSubview(shadowView)

    shadowView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shadowView.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: -6),
      shadowView.heightAnchor.constraint(equalToConstant: 5),
      shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }

  func createShimmerCollectionView() {
    let layoutFlow = UICollectionViewFlowLayout()
//    layoutFlow.sectionInset = UIEdgeInsets(
//      top: view.safeAreaInsets.top + 20,
//      left: 0,
//      bottom: 0,
//      right: 0
//    )
//    layoutFlow.headerReferenceSize = CGSize(width: view.frame.size.width, height: 0)
//    layoutFlow.itemSize = CGSize(width: view.frame.size.width, height: 235)
    layoutFlow.scrollDirection = .vertical
    layoutFlow.minimumLineSpacing = 16

    shimmerCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: layoutFlow)

    view.addSubview(shimmerCollectionView)
    shimmerCollectionView.delegate = self
    shimmerCollectionView.dataSource = self
    shimmerCollectionView.backgroundColor = .clear
    shimmerCollectionView.alwaysBounceVertical = true

    shimmerCollectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
      shimmerCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      shimmerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      shimmerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    // List height / cell  height
    numberOfShimmers = Int((shimmerCollectionView.frame.size.height / 235).rounded(.up)) + 1

    // Shimmer cell
    shimmerCollectionView.register(
      OrdersShimmerCollectionViewCell.self,
      forCellWithReuseIdentifier: OrdersShimmerCollectionViewCell.identifier
    )

    // Header cell
    shimmerCollectionView.register(
      OrdersHeaderCollectionViewCell.self,
      forCellWithReuseIdentifier: OrdersHeaderCollectionViewCell.identifier
    )

    // Header section
    shimmerCollectionView.register(
      OrdersCollectionFooterReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: OrdersCollectionFooterReusableView.identifier
    )

    // Footer section
    shimmerCollectionView.register(
      OrdersCollectionFooterReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: OrdersCollectionFooterReusableView.identifier
    )
  }

  func createFeedbackStateView() {
    view.addSubview(feedbackStateView)

    feedbackStateView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      feedbackStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      feedbackStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      feedbackStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    createFeedbackStateIcon()
    createFeedbackStateLabel()
    createFeedbackStateButton()
  }

  func createFeedbackStateIcon() {
    feedbackStateIcon.image = Images.basket
    feedbackStateView.addSubview(feedbackStateIcon)

    feedbackStateIcon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      feedbackStateIcon.topAnchor.constraint(
        equalTo: feedbackStateView.topAnchor,
        constant: 32
      ),
      feedbackStateIcon.centerXAnchor.constraint(equalTo: feedbackStateView.centerXAnchor),
      feedbackStateIcon.widthAnchor.constraint(equalToConstant: 59),
      feedbackStateIcon.heightAnchor.constraint(equalToConstant: 73)
    ])
  }

  func createFeedbackStateLabel() {
    feedbackMessage.font = .systemFont(ofSize: 16)
    feedbackMessage.textColor = UIColor.Zeplin.grayLight
    feedbackMessage.textAlignment = .center
    feedbackMessage.numberOfLines = 0
    feedbackMessage.text = """
    Ops! Você ainda não possui um histórico de compras realizadas em nossas lojas físicas.
    Pro seu histórico aparecer aqui, lembre sempre de informar seu CPF na hora do pagamento em uma de nossas lojas :)
    """
    feedbackStateView.addSubview(feedbackMessage)

    feedbackMessage.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      feedbackMessage.topAnchor.constraint(equalTo: feedbackStateIcon.bottomAnchor, constant: 12),
      feedbackMessage.leadingAnchor
        .constraint(equalTo: feedbackStateView.leadingAnchor, constant: 20),
      feedbackMessage.trailingAnchor
        .constraint(equalTo: feedbackStateView.trailingAnchor, constant: -20)
    ])
  }

  func createFeedbackStateButton() {
    feedbackStateButton.layer.cornerRadius = 4
    feedbackStateButton.layer.borderWidth = 2
    feedbackStateButton.layer.borderColor = UIColor.Zeplin.redBranding.cgColor

    let attributedString = NSAttributedString(
      string: "ver loja mais próxima",
      attributes: [
        NSAttributedString.Key.foregroundColor: UIColor.Zeplin.redBranding,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
      ]
    )
    feedbackStateButton.setAttributedTitle(attributedString, for: .normal)
    feedbackStateView.addSubview(feedbackStateButton)
    feedbackStateButton.addTarget(
      self,
      action: #selector(onFeedbackButtonAction),
      for: .touchUpInside
    )

    feedbackStateButton.translatesAutoresizingMaskIntoConstraints = false

    feedbackStateButtonWidthConstraint = feedbackStateButton.widthAnchor
      .constraint(equalToConstant: 155)
    feedbackStateButtonWidthConstraint?.isActive = true

    NSLayoutConstraint.activate([
      feedbackStateButton.topAnchor.constraint(equalTo: feedbackMessage.bottomAnchor, constant: 24),
      feedbackStateButton.centerXAnchor.constraint(equalTo: feedbackStateView.centerXAnchor),
      feedbackStateButton.heightAnchor.constraint(equalToConstant: 40),
      feedbackStateButton.bottomAnchor.constraint(
        equalTo: feedbackStateView.bottomAnchor,
        constant: -20
      )
    ])
  }
}
