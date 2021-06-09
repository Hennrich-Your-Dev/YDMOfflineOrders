//
//  YDMessageField.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 22/10/20.
//

import UIKit
import YDExtensions
import YDB2WAssets

public class CustomUITextField: UITextField {
  public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(UIResponderStandardEditActions.paste(_:)) {
      return false
    }

    return super.canPerformAction(action, withSender: sender)
  }
}

public class YDMessageField: UIView {
  // MARK: Enum
  public enum FieldStage: String {
    case normal
    case typing
    case sending
    case error
    case delay
  }

  enum ActionButtonType: String {
    case send
    case like
    case reload
    case sending
    case delay
  }

  // MARK: Properties
  public weak var delegate: YDMessageFieldDelegate?

  public var delayInterval: TimeInterval = 5

  var hintText = "Escreva algo..."

  var hasUserPhoto = false
  var likeButtonEnabled = true

  var actionButtonType: ActionButtonType = .like {
    didSet {
      if oldValue == .reload || oldValue == .delay {
        messageFieldTrailingConstraint.constant -= 108
      }

      if actionButtonType == .delay {
        return
      }

      if actionButtonType == .sending {
        actionButton.isHidden = true
        messageField.textColor = UIColor.Zeplin.grayLight
        return
      }

      let icon: UIImage? = {
        if actionButtonType == .send {
          return Icons.chatWired
        }

        if actionButtonType == .like {
          return Icons.thumbUpWired
        }

        return Icons.reload
      }()

      let likeIcon: UIImage? = likeButtonEnabled ? Icons.thumbUpWired : nil

      actionButton.setImage(likeIcon, for: .selected)
      actionButton.setImage(icon, for: .normal)
      actionButton.isHidden = false

      actionButton.tintColor = actionButton.isEnabled ? UIColor.Zeplin.colorPrimaryLight : UIColor.Zeplin.grayDisabled

      messageField.textColor = UIColor.Zeplin.black
    }
  }

  var sendTimer: Timer?

  // MARK: IBOutlets
  @IBOutlet var contentView: UIView!

  @IBOutlet public weak var messageField: CustomUITextField! {
    didSet {
      messageField.delegate = self

      messageField.addTarget(self, action: #selector(onTextFieldChange), for: .editingChanged)
      messageField.addTarget(self, action: #selector(onTextFieldFocus), for: .editingDidBegin)
      messageField.addTarget(self, action: #selector(onTextFieldBlur), for: .editingDidEnd)

      messageField.attributedPlaceholder = NSAttributedString(
        string: hintText,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.Zeplin.grayNight]
      )

      messageField.autocapitalizationType = .sentences
    }
  }

  @IBOutlet weak var messageLimitCount: UILabel!

  @IBOutlet weak var messageFieldTrailingConstraint: NSLayoutConstraint!

  @IBOutlet public weak var actionButton: UIButton!

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  @IBOutlet weak var errorMessageLabel: UILabel!

  @IBOutlet weak var delayMessageLabel: UILabel!

  // MARK: Life cycle
  public override init(frame: CGRect) {
    super.init(frame: frame)
    instanceXib()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    instanceXib()
  }

  private func instanceXib() {
    contentView = loadNib()
    addSubview(contentView)

    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: self.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])

    changeStage(.normal)
  }

  // MARK: IBActions
  @IBAction func onAction(_ sender: UIButton?) {
    if actionButtonType == .reload {
      onReloadAction()
      return
    }

    if actionButtonType == .like {
      actionButton.isSelected = true
      delegate?.onLike()

      Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] _ in
        self?.actionButton.isSelected = false
      }
      return
    }

    if let message = messageField.text, !message.isEmpty {
      actionButton.isEnabled = false
      changeStage(.sending)
      delegate?.sendMessage(message)
    }
  }

  // MARK: Actions
  private func onReloadAction() {
    changeStage(.sending)

    if let message = messageField.text {
      delegate?.sendMessage(message)
    }
  }

  // MARK: Public actions
  public func changeStage(_ stage: FieldStage) {
    switch stage {
    case .normal:
      normalStage()

    case .typing:
      typingStage()

    case .sending:
      sendingStage()

    case .delay:
      delayStage()

    case .error:
      errorStage()
    }
  }

  public func config(username: String) {
    hintText = "Escreva algo, \(username)..."
    messageField.attributedPlaceholder = NSAttributedString(
      string: hintText,
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.Zeplin.grayNight]
    )
  }

  public func cleanField() {
    messageField.text = nil
    messageLimitCount.text = "0/120"
  }

  public func focusField() {
    messageField.becomeFirstResponder()
    messageLimitCount.isHidden = false
  }

  public func blurField() {
    messageField.resignFirstResponder()
    messageLimitCount.isHidden = true

    if messageField.text?.isEmpty ?? false {
      changeStage(.normal)
    }
  }

  public func disableLikeButton() {
    likeButtonEnabled = false
    actionButton.isEnabled = false
    changeStage(.typing)
  }
}

// MARK: Stages
extension YDMessageField {
  func normalStage() {
    messageField.text = nil
    messageField.resignFirstResponder()

    actionButton.isEnabled = likeButtonEnabled
    actionButtonType = likeButtonEnabled ? .like : .send

    activityIndicator.stopAnimating()

    errorMessageLabel.isHidden = true
    delayMessageLabel.isHidden = true
    messageLimitCount.isHidden = true

    sendTimer?.invalidate()
  }

  func typingStage() {
    if messageField.text?.isEmpty ?? true {
      actionButton.isEnabled = false
    } else {
      actionButton.isEnabled = true
    }

    activityIndicator.stopAnimating()
    actionButtonType = .send
    errorMessageLabel.isHidden = true
    delayMessageLabel.isHidden = true
    sendTimer?.invalidate()
  }

  func sendingStage() {
    activityIndicator.startAnimating()
    actionButtonType = .sending
    errorMessageLabel.isHidden = true
    delayMessageLabel.isHidden = true

    sendTimer?.invalidate()
    sendTimer = Timer.scheduledTimer(
      withTimeInterval: delayInterval,
      repeats: false
    ) { [weak self] _ in
      self?.changeStage(.delay)
    }
  }

  func delayStage() {
    actionButtonType = .delay
    errorMessageLabel.isHidden = true
    delayMessageLabel.isHidden = false
    messageFieldTrailingConstraint.constant += 108
  }

  func errorStage() {
    activityIndicator.stopAnimating()
    actionButton.isEnabled = true
    actionButtonType = .reload
    errorMessageLabel.isHidden = false
    delayMessageLabel.isHidden = true
    messageFieldTrailingConstraint.constant += 108
    messageField.resignFirstResponder()
    messageLimitCount.isHidden = true
    sendTimer?.invalidate()
  }
}

// MARK: Text Field Delegate
extension YDMessageField: UITextFieldDelegate {
  @objc func onTextFieldChange(_ textField: UITextField) {
    if textField.text?.count == 1 {
      actionButton.isEnabled = true
      changeStage(.typing)
    } else {
      if actionButtonType == .reload {
        errorMessageLabel.isHidden = true
      }

      if (textField.text?.isEmpty ?? false) && !likeButtonEnabled {
        actionButton.isEnabled = false
      }

      actionButtonType = .send
    }

    messageLimitCount.text = "\(textField.text?.count ?? 0)/120"
  }

  @objc func onTextFieldFocus() {
    messageLimitCount.isHidden = false

    if messageField.text?.isEmpty ?? true {
      actionButton.isEnabled = false
    }

    messageLimitCount.text = "\(messageField.text?.count ?? 0)/120"
    changeStage(.typing)
  }

  @objc func onTextFieldBlur() {
    if messageField.text?.isEmpty ?? true {
      changeStage(.normal)
    }
  }

  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = textField.text ?? ""

    // attempt to read the range they are trying to change, or exit if we can't
    guard let stringRange = Range(range, in: currentText) else { return false }

    // add their new text to the existing text
    let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

    return updatedText.count <= 120
  }

  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    onAction(nil)
    return true
  }
}
