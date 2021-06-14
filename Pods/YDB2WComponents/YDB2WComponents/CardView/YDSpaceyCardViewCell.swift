//
//  YDSpaceyCardViewCell.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 11/06/21.
//

import UIKit
import YDB2WModels

public class YDSpaceyCardViewCell: UICollectionViewCell {
  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  let topCardView = YDSpaceyCardView()
  let behindCardView = YDSpaceyCardView()

  // MARK: Init
  public override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    topCardView.cleanUpCard()
  }

  public override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
    width.constant = bounds.size.width
    return contentView.systemLayoutSizeFitting(
      CGSize(width: targetSize.width, height: 1)
    )
  }

  // MARK: Actions
  public func configure(with cards: [YDSpaceyCard]) {
    //
    guard let card = cards.first else { return }

    topCardView.configure(with: card)
  }
}

// MARK: UI
extension YDSpaceyCardViewCell {
  func configureLayout() {
    contentView.addSubview(topCardView)

    NSLayoutConstraint.activate([
      topCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
      topCardView.leadingAnchor
        .constraint(equalTo: contentView.leadingAnchor, constant: 16),
      topCardView.trailingAnchor
        .constraint(equalTo: contentView.trailingAnchor, constant: -16),
      topCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
    ])

    //
    contentView.addSubview(behindCardView)
    contentView.sendSubviewToBack(behindCardView)

    NSLayoutConstraint.activate([
      behindCardView.topAnchor.constraint(equalTo: topCardView.topAnchor, constant: 12),
      behindCardView.leadingAnchor
        .constraint(equalTo: topCardView.leadingAnchor, constant: 10),
      behindCardView.trailingAnchor
        .constraint(equalTo: topCardView.trailingAnchor, constant: -10),
      behindCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
