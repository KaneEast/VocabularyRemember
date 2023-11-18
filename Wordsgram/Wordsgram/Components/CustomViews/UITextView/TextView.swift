//
//  TextView.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/19.
//

import SwiftUI
public struct TextView: View {
  @Environment(\.layoutDirection) private var layoutDirection

  @Binding private var text: NSMutableAttributedString
  @Binding private var isEmpty: Bool

  @State private var calculatedHeight: CGFloat = 44

  private var getTextView: ((UITextView) -> Void)?

  var placeholderView: AnyView?
  var placeholderText: String?
  var keyboard: UIKeyboardType = .default

  /// Makes a new TextView that supports `NSAttributedString`
  /// - Parameters:
  ///   - text: A binding to the attributed text
  public init(_ text: Binding<NSMutableAttributedString>,
              getTextView: ((UITextView) -> Void)? = nil)
  {
    _text = text
    _isEmpty = Binding(
      get: { text.wrappedValue.string.isEmpty },
      set: { _ in }
    )

    self.getTextView = getTextView
  }

  public var body: some View {
    Representable(
      text: $text,
      calculatedHeight: $calculatedHeight,
      keyboard: keyboard,
      getTextView: getTextView
    )
    .frame(
      minHeight: calculatedHeight,
      maxHeight: calculatedHeight
    )
    .accessibilityValue($text.wrappedValue.string.isEmpty ? (placeholderText ?? "") : $text.wrappedValue.string)
    .background(
      placeholderView?
        .foregroundColor(Color(.placeholderText))
        .multilineTextAlignment(.leading)
        .font(.scaledBody)
        .padding(.horizontal, 0)
        .padding(.vertical, 0)
        .opacity(isEmpty ? 1 : 0)
        .accessibilityHidden(true),
      alignment: .topLeading
    )
  }
}

extension TextView {
  struct Representable: UIViewRepresentable {
    @Binding var text: NSMutableAttributedString
    @Binding var calculatedHeight: CGFloat
    @Environment(\.sizeCategory) var sizeCategory

    let keyboard: UIKeyboardType
    var getTextView: ((UITextView) -> Void)?

    func makeUIView(context: Context) -> UIKitTextView {
      context.coordinator.textView
    }

    func updateUIView(_: UIKitTextView, context: Context) {
      context.coordinator.update(representable: self)
      if !context.coordinator.didBecomeFirstResponder {
        context.coordinator.textView.becomeFirstResponder()
        context.coordinator.didBecomeFirstResponder = true
      }
    }

    @discardableResult func makeCoordinator() -> Coordinator {
      Coordinator(
        text: $text,
        calculatedHeight: $calculatedHeight,
        sizeCategory: sizeCategory,
        getTextView: getTextView
      )
    }
  }
}

final class UIKitTextView: UITextView {
  override var keyCommands: [UIKeyCommand]? {
    (super.keyCommands ?? []) + [
      UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(escape(_:))),
    ]
  }

  @objc private func escape(_: Any) {
    resignFirstResponder()
  }
}

extension TextView.Representable {
  final class Coordinator: NSObject, UITextViewDelegate {
    let textView: UIKitTextView

    private var originalText: NSMutableAttributedString = .init()
    private var text: Binding<NSMutableAttributedString>
    private var sizeCategory: ContentSizeCategory
    private var calculatedHeight: Binding<CGFloat>

    var didBecomeFirstResponder = false

    var getTextView: ((UITextView) -> Void)?

    init(text: Binding<NSMutableAttributedString>,
         calculatedHeight: Binding<CGFloat>,
         sizeCategory: ContentSizeCategory,
         getTextView: ((UITextView) -> Void)?)
    {
      textView = UIKitTextView()
      textView.backgroundColor = .clear
      textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      textView.isScrollEnabled = false
      textView.textContainer.lineFragmentPadding = 0
      textView.textContainerInset = .zero

      self.text = text
      self.calculatedHeight = calculatedHeight
      self.sizeCategory = sizeCategory
      self.getTextView = getTextView

      super.init()

      textView.delegate = self

      textView.font = Font.scaledBodyUIFont
      textView.adjustsFontForContentSizeCategory = true
      textView.autocapitalizationType = .sentences
      textView.autocorrectionType = .yes
      textView.isEditable = true
      textView.isSelectable = true
      textView.dataDetectorTypes = []
      textView.allowsEditingTextAttributes = false
      textView.returnKeyType = .default
      textView.allowsEditingTextAttributes = true
      if ProcessInfo.processInfo.isiOSAppOnMac {
        textView.inlinePredictionType = .no
      }

      self.getTextView?(textView)
    }

    func textViewDidBeginEditing(_: UITextView) {
      originalText = text.wrappedValue
      DispatchQueue.main.async {
        self.recalculateHeight()
      }
    }

    func textViewDidChange(_ textView: UITextView) {
      DispatchQueue.main.async {
        self.text.wrappedValue = NSMutableAttributedString(attributedString: textView.attributedText)
        self.recalculateHeight()
      }
    }

    func textView(_: UITextView, shouldChangeTextIn _: NSRange, replacementText _: String) -> Bool {
      true
    }
  }
}

extension TextView.Representable.Coordinator {
  func update(representable: TextView.Representable) {
    textView.keyboardType = representable.keyboard
    recalculateHeight()
    textView.setNeedsDisplay()
  }

  private func recalculateHeight() {
    let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
    guard calculatedHeight.wrappedValue != newSize.height else { return }

    DispatchQueue.main.async { // call in next render cycle.
      self.calculatedHeight.wrappedValue = newSize.height
    }
  }
}
