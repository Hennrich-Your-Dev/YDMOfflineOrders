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
  // MARK: Properties
  public var updateTimer: Timer?

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
    updateTimer?.invalidate()

    updateTimer = Timer.scheduledTimer(
      withTimeInterval: 1,
      repeats: true
    ) { [weak self] _ in
      guard let self = self else {
        self?.updateTimer?.invalidate()
        return
      }

      self.updateCountDown(with: date)
    }
  }

  public func stopTimer() {
    updateTimer?.invalidate()
    daysView.resetComponent()
    hoursView.resetComponent()
    minutesView.resetComponent()
    secondsView.resetComponent()
  }

  @objc func updateCountDown(with date: Date) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      let now = Date()

      if date < now {
        self.stopTimer()
        return
      }

      let diff = Calendar.current.dateComponents(
        [.day, .hour, .minute, .second],
        from: now,
        to: date
      )

      if diff.second != nil {
        let (first, last) = self.getFirstAndLast(from: diff.second ?? 0)
        self.secondsView.update(left: first, right: last)
      }

      if diff.minute != nil {
        let (first, last) = self.getFirstAndLast(from: diff.minute ?? 0)
        self.minutesView.update(left: first, right: last)
      }

      if diff.hour != nil {
        let (first, last) = self.getFirstAndLast(from: diff.hour ?? 0)
        self.hoursView.update(left: first, right: last)
      }

      if diff.day != nil {
        let (first, last) = self.getFirstAndLast(from: diff.day ?? 0)
        self.daysView.update(left: first, right: last)
      }
    }
  }

  private func getFirstAndLast(from number: Int) -> (first: String?, last: String?) {
    if number >= 10,
       let firstNumber = "\(number)".first,
       let lastNumber = "\(number)".last {
      return (String(firstNumber), String(lastNumber))
    } else {
      return ("0", "\(number)")
    }
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
    stackView.spacing = 5
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
