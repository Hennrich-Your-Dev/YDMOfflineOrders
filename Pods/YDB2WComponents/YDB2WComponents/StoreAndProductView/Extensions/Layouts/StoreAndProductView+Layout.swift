//
//  StoreAndProductView+Layout.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 25/03/21.
//

import UIKit

import YDExtensions

extension YDStoreAndProductView {
  func setUpLayouts() {
    createStoreAndAddressView()
    createSeparatorView()
    createProductCardView()
    createSegmentedControl()
    createTextView()
    createTableView()

    // Shimmer
    createTextViewShimmer()
  }

  // Store & Address
  private func createStoreAndAddressView() {
    addSubview(storeNameAndAddressView)

    storeNameAndAddressView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      storeNameAndAddressView.topAnchor.constraint(equalTo: topAnchor),
      storeNameAndAddressView.leadingAnchor.constraint(equalTo: leadingAnchor),
      storeNameAndAddressView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])

    storeNameAndAddressView.callback = { [weak self] in
      guard let self = self else { return }
      self.delegate?.onChangeStoreAction()
    }
  }

  // Separator line
  private func createSeparatorView() {
    separatorView.backgroundColor = UIColor.Zeplin.grayDisabled
    addSubview(separatorView)

    separatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      separatorView.topAnchor.constraint(equalTo: storeNameAndAddressView.bottomAnchor),
      separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
      separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
      separatorView.heightAnchor.constraint(equalToConstant: 1)
    ])
  }

  // Product Info
  private func createProductCardView() {
    addSubview(productCardView)
    productCardView.layer.shadowOpacity = 0

    productCardView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productCardView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
      productCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
      productCardView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }

  // Segmented Control
  private func createSegmentedControl() {
    segmentedControl.delegate = self
    segmentedControl.setItems(["descrição", "informações"])
    addSubview(segmentedControl)

    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      segmentedControl.topAnchor.constraint(equalTo: productCardView.bottomAnchor),
      segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])
  }

  // Text View
  private func createTextView() {
    textView.backgroundColor = .clear
    textView.textColor = UIColor.Zeplin.grayLight
    textView.font = .systemFont(ofSize: 14)
    textView.textAlignment = .left
    textView.isEditable = false
    textView.alwaysBounceVertical = true
    textView.delegate = self
    addSubview(textView)

    textView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 18),
      textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
    ])
  }

  // TableView
  private func createTableView() {
    tableView.backgroundColor = .clear
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.isHidden = true
    addSubview(tableView)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 18),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
    ])

    tableView.register(
      StoreAndProductTableViewCell.self,
      forCellReuseIdentifier: StoreAndProductTableViewCell.identifier
    )

    tableView.reloadData()
  }
}

// MARK: Shimmer Layout
extension YDStoreAndProductView {
  func createTextViewShimmer() {
    shimmerTextView.isHidden = true
    addSubview(shimmerTextView)

    shimmerTextView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerTextView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 18),
      shimmerTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      shimmerTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      shimmerTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
    ])

    let firstView = UIView()
    firstView.backgroundColor = .white
    firstView.layer.cornerRadius = 4
    shimmerTextView.addSubview(firstView)

    firstView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      firstView.topAnchor.constraint(equalTo: shimmerTextView.topAnchor),
      firstView.leadingAnchor.constraint(equalTo: shimmerTextView.leadingAnchor),
      firstView.trailingAnchor.constraint(equalTo: shimmerTextView.trailingAnchor),
      firstView.heightAnchor.constraint(equalToConstant: 13)
    ])

    let secoundView = UIView()
    secoundView.backgroundColor = .white
    secoundView.layer.cornerRadius = 4
    shimmerTextView.addSubview(secoundView)

    secoundView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      secoundView.topAnchor.constraint(equalTo: firstView.bottomAnchor, constant: 6),
      secoundView.leadingAnchor.constraint(equalTo: shimmerTextView.leadingAnchor),
      secoundView.trailingAnchor.constraint(
        equalTo: shimmerTextView.trailingAnchor,
        constant: -50
      ),
      secoundView.heightAnchor.constraint(equalToConstant: 13)
    ])
  }
}
