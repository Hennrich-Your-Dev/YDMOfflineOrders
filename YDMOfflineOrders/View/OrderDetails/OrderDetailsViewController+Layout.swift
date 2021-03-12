//
//  OrderDetailsViewController+Layout.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 12/03/21.
//

import UIKit

import YDExtensions
import YDB2WAssets
import YDB2WModels

extension OrderDetailsViewController {
  func setUpLayout() {
    view.backgroundColor = UIColor.Zeplin.white
    setUpNavBar()

    guard let order = viewModel?.order else { return }

    let storeNameLabel = createStoreNameLabel(order)
    let addressLabel = createAddressLabel(order, parent: storeNameLabel)
    let dateAndTotalLabel = createDateAndTotalItems(order, parent: addressLabel)
    createSeparatorView(parent: dateAndTotalLabel)
    createCollectionView()
  }

  func setUpNavBar() {
    let backButtonView = UIButton()
    backButtonView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    backButtonView.layer.cornerRadius = 16
    backButtonView.layer.applyShadow()
    backButtonView.backgroundColor = .white
    backButtonView.setImage(Icons.leftArrow, for: .normal)
    backButtonView.addTarget(self, action: #selector(onBackAction), for: .touchUpInside)

    let backButton = UIBarButtonItem()
    backButton.customView = backButtonView

    navigationItem.leftBarButtonItem = backButton

    title = "detalhes da compra"
  }

  func createStoreNameLabel(_ order: YDOfflineOrdersOrder) -> UILabel {
    let nameLabel = UILabel()
    nameLabel.textColor = UIColor.Zeplin.black
    nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
    nameLabel.textAlignment = .left
    nameLabel.text = order.storeName

    view.addSubview(nameLabel)

    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 32
      ),
      nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
      nameLabel.heightAnchor.constraint(equalToConstant: 18)
    ])

    return nameLabel
  }

  func createAddressLabel(_ order: YDOfflineOrdersOrder, parent: UILabel) -> UILabel {
    let addressLabel = UILabel()
    addressLabel.font = .systemFont(ofSize: 14)
    addressLabel.textAlignment = .left
    addressLabel.textColor = UIColor.Zeplin.grayLight
    addressLabel.numberOfLines = 2
    addressLabel.text = order.formatedAddress

    view.addSubview(addressLabel)

    addressLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      addressLabel.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 7),
      addressLabel.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
      addressLabel.trailingAnchor.constraint(equalTo: parent.trailingAnchor)
    ])

    return addressLabel
  }

  func createDateAndTotalItems(_ order: YDOfflineOrdersOrder, parent: UILabel) -> UILabel {
    let dateLabel = UILabel()
    dateLabel.font = .systemFont(ofSize: 13)
    dateLabel.textAlignment = .left
    dateLabel.textColor = UIColor.Zeplin.grayLight
    dateLabel.text = order.formatedDate
    view.addSubview(dateLabel)

    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(
        equalTo: parent.bottomAnchor,
        constant: 21
      ),
      dateLabel.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
      dateLabel.heightAnchor.constraint(equalToConstant: 16),
      dateLabel.widthAnchor.constraint(equalToConstant: 137)
    ])
    dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    let productsCount = UILabel()
    productsCount.font = .systemFont(ofSize: 13)
    productsCount.textAlignment = .right
    productsCount.textColor = UIColor.Zeplin.black
    productsCount.text = "total de produtos: \(order.products?.count ?? 1)"
    view.addSubview(productsCount)

    productsCount.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productsCount.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
      productsCount.leadingAnchor.constraint(
        equalTo: dateLabel.trailingAnchor,
        constant: 50
      ),
      productsCount.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
      productsCount.heightAnchor.constraint(equalToConstant: 16)
    ])
    productsCount.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    return dateLabel
  }

  func createSeparatorView(parent: UILabel) {
    separatorView.backgroundColor = UIColor.Zeplin.grayDisabled
    view.addSubview(separatorView)

    separatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      separatorView.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 13),
      separatorView.heightAnchor.constraint(equalToConstant: 1),
      separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
    ])
  }

  func createCollectionView() {
    let layoutFlow = UICollectionViewFlowLayout()
    layoutFlow.sectionInset = UIEdgeInsets(
      top: 5,
      left: 0,
      bottom: 0,
      right: 0
    )

    layoutFlow.headerReferenceSize = CGSize(width: view.frame.size.width, height: 20)
    layoutFlow.itemSize = CGSize(width: view.frame.size.width, height: 50)
    layoutFlow.scrollDirection = .vertical
    layoutFlow.minimumLineSpacing = 16

    collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layoutFlow)
    view.addSubview(collectionView)

    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .clear
    collectionView.alwaysBounceVertical = true

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    collectionView.register(
      OrderDetailsCollectionViewCell.self,
      forCellWithReuseIdentifier: OrderDetailsCollectionViewCell.identifier
    )

    collectionView.register(
      OrdersCollectionFooterReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: OrdersCollectionFooterReusableView.identifier
    )

    collectionView.register(
      OrdersCollectionFooterReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: OrdersCollectionFooterReusableView.identifier
    )
  }
}
