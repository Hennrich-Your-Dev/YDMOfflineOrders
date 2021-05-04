//
//  YDMFindStoreViewController+Layouts.swift
//  YDMFindStore
//
//  Created by Douglas Hennrich on 23/04/21.
//

import UIKit

import YDExtensions

// MARK: Layout
extension YDMFindStoreViewController {
  func createVerticalListLayout() {
    createBlurViewEffect()
    createVerticalListContainer()
    createHowManyStoresVertical()
    createVerticalCollectionView()
  }

  // Blur View Effect
  func createBlurViewEffect() {
    view.insertSubview(blurView, at: 1)
    blurView.isHidden = true

    blurView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      blurView.topAnchor.constraint(equalTo: view.topAnchor),
      blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    if #available(iOS 13.0, *) {
      let effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
      blurView.effect = effect
    } else {
      let effect = UIBlurEffect(style: .dark)
      blurView.effect = effect
    }
  }

  // Vertical List Container
  func createVerticalListContainer() {
    view.addSubview(verticalListContainer)
    verticalListContainer.isHidden = true

    verticalListContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      verticalListContainer.topAnchor.constraint(
        equalTo: locationContainer.bottomAnchor,
        constant: 32
      ),
      verticalListContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      verticalListContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      verticalListContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  // How many stores
  func createHowManyStoresVertical() {
    verticalListContainer.addSubview(howManyStoresVerticalLabel)

    howManyStoresVerticalLabel.font = .boldSystemFont(ofSize: 17)
    howManyStoresVerticalLabel.text = "%d Americanas perto de você"
    howManyStoresVerticalLabel.textColor = .white
    howManyStoresVerticalLabel.textAlignment = .left

    howManyStoresVerticalLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      howManyStoresVerticalLabel.topAnchor.constraint(
        equalTo: verticalListContainer.topAnchor
      ),
      howManyStoresVerticalLabel.leadingAnchor.constraint(
        equalTo: verticalListContainer.leadingAnchor,
        constant: 16
      ),
      howManyStoresVerticalLabel.trailingAnchor.constraint(
        equalTo: verticalListContainer.trailingAnchor,
        constant: -16
      ),
      howManyStoresVerticalLabel.heightAnchor.constraint(equalToConstant: 17)
    ])
  }

  // Vertical CollectionView
  func createVerticalCollectionView() {
    verticalListContainer.addSubview(verticalCollectionView)

    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 16
    layout.itemSize = CGSize(width: view.frame.size.width - 32, height: 130)
    layout.sectionInset = UIEdgeInsets(
      top: 12,
      left: 0,
      bottom: view.safeAreaInsets.bottom + 20,
      right: 0
    )

    verticalCollectionView.backgroundColor = .clear
    verticalCollectionView.collectionViewLayout = layout
    verticalCollectionView.dataSource = self
    verticalCollectionView.delegate = self

    // Register cell & header/footer
    let bundle = Bundle.init(for: YDMFindStoreViewController.self)
    let storeCard = YDMFindStoreStoreCardCollectionViewCell.loadNib(bundle)

    verticalCollectionView.register(
      storeCard,
      forCellWithReuseIdentifier: YDMFindStoreStoreCardCollectionViewCell.identifier
    )

    // Auto layout
    verticalCollectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      verticalCollectionView.topAnchor.constraint(
        equalTo: howManyStoresVerticalLabel.bottomAnchor,
        constant: 8
      ),
      verticalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      verticalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      verticalCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}
