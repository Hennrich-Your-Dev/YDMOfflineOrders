//
//  YDMOfflineOrdersViewController+Layout.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 22/02/21.
//

import UIKit

extension YDMOfflineOrdersViewController {
  func setUpLayout() {
    createCollectionView()
    createShadowView()
    createShimmerCollectionView()
  }

  func createCollectionView() {
    let layoutFlow = UICollectionViewFlowLayout()
    layoutFlow.sectionInset = UIEdgeInsets(
      top: view.safeAreaInsets.top + 20,
      left: 0,
      bottom: 0,
      right: 0
    )

    layoutFlow.headerReferenceSize = CGSize(width: view.frame.size.width, height: 20)
    layoutFlow.itemSize = CGSize(width: view.frame.size.width, height: 235)
    layoutFlow.scrollDirection = .vertical
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
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    collectionView.register(
      OrdersCollectionViewCell.self,
      forCellWithReuseIdentifier: OrdersCollectionViewCell.identifier
    )

    collectionView.register(
      OrdersCollectionReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: OrdersCollectionReusableView.identifier
    )

    collectionView.register(
      OrdersCollectionFooterReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: OrdersCollectionFooterReusableView.identifier
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
    layoutFlow.sectionInset = UIEdgeInsets(
      top: view.safeAreaInsets.top + 20,
      left: 0,
      bottom: 0,
      right: 0
    )

    layoutFlow.headerReferenceSize = CGSize(width: view.frame.size.width, height: 20)
    layoutFlow.itemSize = CGSize(width: view.frame.size.width, height: 235)
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

    shimmerCollectionView.register(
      OrdersShimmerCollectionViewCell.self,
      forCellWithReuseIdentifier: OrdersShimmerCollectionViewCell.identifier
    )

    shimmerCollectionView.register(
      OrdersCollectionReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: OrdersCollectionReusableView.identifier
    )

    shimmerCollectionView.register(
      OrdersCollectionFooterReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: OrdersCollectionFooterReusableView.identifier
    )
  }
}
