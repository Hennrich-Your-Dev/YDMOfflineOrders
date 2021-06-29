//
//  YDSpaceyCardViewCell.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 11/06/21.
//

import UIKit
import YDB2WModels

public class YDSpaceyCardViewCell: UICollectionViewCell {
  // MARK: Enum
  private enum CardType {
    case first
    case second
  }

  // MARK: Properties
  let cardPadding: CGFloat = 32
  let cardSmallPadding: CGFloat = 20

  var cardsViews: [YDSpaceyCardView] = []
  var cards: [YDSpaceyComponentLiveNPSCardQuestion] = []

  var canTouchFirstCard = true
  var canTouchSecondCard = false

  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()

  let firstCardView = YDSpaceyCardView()
  lazy var firstCardWidthConstraint: NSLayoutConstraint = {
    let width = firstCardView.widthAnchor.constraint(equalToConstant: 300)
    width.isActive = true
    return width
  }()
  lazy var firstCardTopConstraint: NSLayoutConstraint = {
    firstCardView.topAnchor.constraint(equalTo: contentView.topAnchor)
  }()
  lazy var firstCardLeadingConstraint: NSLayoutConstraint = {
    firstCardView.leadingAnchor
      .constraint(equalTo: contentView.leadingAnchor, constant: 16)
  }()
  lazy var firstCardCenterXConstraint: NSLayoutConstraint = {
    firstCardView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
  }()

  let secondCardView = YDSpaceyCardView()
  lazy var secondCardWidthConstraint: NSLayoutConstraint = {
    let width = secondCardView.widthAnchor.constraint(equalToConstant: 300)
    width.isActive = true
    return width
  }()
  lazy var secondCardTopConstraint: NSLayoutConstraint = {
    secondCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
  }()
  lazy var secondCardLeadingConstraint: NSLayoutConstraint = {
    secondCardView.leadingAnchor
      .constraint(equalTo: contentView.leadingAnchor, constant: 16)
  }()
  lazy var secondCardCenterXConstraint: NSLayoutConstraint = {
    secondCardView.centerXAnchor
      .constraint(equalTo: contentView.centerXAnchor)
  }()

  // MARK: Init
  public override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.heightAnchor.constraint(equalToConstant: 202).isActive = true
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    cards.removeAll()
    firstCardView.cleanUpCard()
    secondCardView.cleanUpCard()
  }

  public override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
    width.constant = bounds.size.width

    firstCardWidthConstraint.constant = bounds.size.width - cardPadding
    secondCardWidthConstraint.constant = bounds.size.width - cardPadding - cardSmallPadding

    return contentView.systemLayoutSizeFitting(
      CGSize(width: targetSize.width, height: 1)
    )
  }

  // MARK: Actions
  public func configure(with cards: [YDSpaceyComponentLiveNPSCard]) {
    if let firstCard = cards.first {
      firstCardView.configure(with: firstCard)
    }

    if let secondCard = cards.at(1) {
      secondCardView.configure(with: secondCard)
    }
  }

  @objc func onTopCardAction(_ gesture: UIGestureRecognizer) {
    guard let index = gesture.view?.tag else { return }
    moveBack(card: index == 0 ? .first : .second)
  }

  private func moveBack(card: CardType) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      if card == .first {
        if !self.canTouchFirstCard { return }

        self.firstCardCenterXConstraint.isActive = false
        self.firstCardLeadingConstraint.isActive = true
        self.firstCardLeadingConstraint.constant = -self.width.constant + 50

        self.secondCardWidthConstraint.constant = self.width.constant - self.cardPadding
        self.secondCardTopConstraint.constant = 0

        UIView.animate(
          withDuration: 0.5) {
          self.contentView.layoutIfNeeded()
        } completion: { _ in
          self.firstCardLeadingConstraint.isActive = false
          self.firstCardCenterXConstraint.isActive = true
          self.firstCardTopConstraint.isActive = true
          self.firstCardTopConstraint.constant = 12
          self.firstCardWidthConstraint.constant = self.width.constant
            - self.cardPadding
            - self.cardSmallPadding

          self.contentView.sendSubviewToBack(self.firstCardView)
          self.contentView.layoutIfNeeded()

          self.canTouchFirstCard = false
          self.canTouchSecondCard = true
        }

        //
      } else {
        if !self.canTouchSecondCard { return }

        self.secondCardCenterXConstraint.isActive = false
        self.secondCardLeadingConstraint.isActive = true
        self.secondCardLeadingConstraint.constant = -self.width.constant + 50

        self.firstCardWidthConstraint.constant = self.width.constant - self.cardPadding
        self.firstCardTopConstraint.constant = 0

        UIView.animate(
          withDuration: 0.5) {
          self.contentView.layoutIfNeeded()
        } completion: { _ in
          self.secondCardLeadingConstraint.isActive = false
          self.secondCardCenterXConstraint.isActive = true
          self.secondCardTopConstraint.isActive = true
          self.secondCardTopConstraint.constant = 12
          self.secondCardWidthConstraint.constant = self.width.constant
            - self.cardPadding
            - self.cardSmallPadding

          self.contentView.sendSubviewToBack(self.secondCardView)
          self.contentView.layoutIfNeeded()

          self.canTouchFirstCard = true
          self.canTouchSecondCard = false
        }
      }
    }
  }
}

// MARK: UI
extension YDSpaceyCardViewCell {
  func configureLayout() {
    contentView.addSubview(firstCardView)
    firstCardView.tag = 0

    firstCardTopConstraint.isActive = true
    firstCardCenterXConstraint.isActive = true
    firstCardView.heightAnchor.constraint(equalToConstant: 190).isActive = true

    firstCardView.addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: #selector(onTopCardAction))
    )

    // Second
    contentView.addSubview(secondCardView)
    contentView.sendSubviewToBack(secondCardView)

    secondCardView.tag = 1
    secondCardTopConstraint.isActive = true
    secondCardCenterXConstraint.isActive = true
    secondCardView.heightAnchor.constraint(equalToConstant: 190).isActive = true

    secondCardView.addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: #selector(onTopCardAction))
    )
  }
}
