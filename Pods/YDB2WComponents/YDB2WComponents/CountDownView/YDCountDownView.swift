//
//  YDCountDownView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 09/06/21.
//

import UIKit
import YDExtensions
import YDB2WModels

public class YDCountDownView: UIView {
  // MARK: Components
  let titleLabel = UILabel()
  let vStackView = UIStackView()
  let stackView = UIStackView()
  let daysView = YDCountDownComponentView(description: "dias")
  let hoursView = YDCountDownComponentView(description: "horas")
  let minutesView = YDCountDownComponentView(description: "minutos")
  let secondsView = YDCountDownComponentView(description: "segundos")

  // MARK: Init
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public init() {
    super.init(frame: .zero)
    configureUI()
  }

  // MARK: Actions
  public func start(with date: Date) {
    //
    hoursView.rightNumberLabel.text = "3"

    minutesView.leftNumberLabel.text = "2"
    minutesView.rightNumberLabel.text = "3"

    secondsView.leftNumberLabel.text = "5"
    secondsView.rightNumberLabel.text = "8"
  }
}

// MARK: UI
extension YDCountDownView {
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white
    layer.cornerRadius = 6

    configureTitleLabel()
    configureStackView()
  }

  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.textColor = Zeplin.black
    titleLabel.font = .boldSystemFont(ofSize: 14)
    titleLabel.textAlignment = .center
    titleLabel.text = "ei, a próxima live começa em:"

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      titleLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  private func configureStackView() {
    addSubview(vStackView)
    vStackView.alignment = .center
    vStackView.axis = .vertical

    vStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      vStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      vStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      vStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      vStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
    ])

    vStackView.addArrangedSubview(stackView)
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.distribution = .fillProportionally

    //
    let firstDots = createSeparatorDots()
    let views = [
      daysView,
      firstDots,
      hoursView,
      createSeparatorDots(),
      minutesView,
      createSeparatorDots(),
      secondsView
    ]

    views.forEach { stackView.addArrangedSubview($0) }
  }

  private func createSeparatorDots() -> UIView {
    let container = UIView()
    let dots = UILabel()
    container.addSubview(dots)
    dots.textColor = Zeplin.grayLight
    dots.font = .boldSystemFont(ofSize: 20)
    dots.text = ":"

    dots.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dots.topAnchor.constraint(equalTo: container.topAnchor, constant: -10),
      dots.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 2),
      dots.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -2),
      dots.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
    ])

    return container
  }
}
