////
////  KeyboardManager.swift
////  Broker Portal
////
////  Created by Pankaj on 14/05/25.
//

import UIKit

final class KeyboardManager: NSObject {
    
    static let shared = KeyboardManager()
    
    private var toolbar: UIToolbar!
    private var keyboardFrame: CGRect = .zero
    private var isKeyboardVisible = false
    
    private override init() {
        super.init()
        configureToolbar()
        registerNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Call this once from AppDelegate
    @MainActor
    func enable() {
        // Assign toolbar globally
        UITextField.appearance().inputAccessoryView = toolbar
        UITextView.appearance().inputAccessoryView = toolbar
    }
    
    // MARK: - Notifications
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Toolbar Configuration
    
    private func configureToolbar() {
        toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = .systemBlue
        toolbar.sizeToFit()
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        toolbar.items = [cancel, flexible, done]
    }
    
    @objc private func doneTapped() {
        UIApplication.shared.sendAction(#selector(UIView.endEditing(_:)), to: nil, from: nil, for: nil)
    }
    
    @objc private func cancelTapped() {
        UIApplication.shared.sendAction(#selector(UIView.endEditing(_:)), to:
                                            nil, from: nil, for: nil)
    }
    
    // MARK: - Keyboard Handling
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        keyboardFrame = frame
        isKeyboardVisible = true
        adjustScrollViewInsets()
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        isKeyboardVisible = false
        resetScrollViewInsets()
    }
    
    private func adjustScrollViewInsets() {
        guard let activeField = findFirstResponder(in: UIApplication.shared.activeWindow?.rootViewController?.view ?? UIView()) as? UIView,
              let scrollView = activeField.findSuperview(of: UIScrollView.self) else { return }
        
        var bottomInset = keyboardFrame.height
        if let window = UIApplication.shared.activeWindow {
            bottomInset -= window.safeAreaInsets.bottom
        }
        
        var contentInset = scrollView.contentInset
        contentInset.bottom = bottomInset + 20
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
        let fieldFrame = activeField.convert(activeField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(fieldFrame, animated: true)
    }
    
    private func resetScrollViewInsets() {
        guard let activeField = findFirstResponder(in: UIApplication.shared.activeWindow?.rootViewController?.view ?? UIView()) as? UIView,
              let scrollView = activeField.findSuperview(of: UIScrollView.self) else { return }
        
        UIView.animate(withDuration: 0.3) {
            scrollView.contentInset = .zero
            scrollView.scrollIndicatorInsets = .zero
        }
    }
    
    // MARK: - Utility Functions
    
    private func findFirstResponder(in view: UIView) -> UIResponder? {
        if view.isFirstResponder { return view }
        for subview in view.subviews {
            if let responder = findFirstResponder(in: subview) {
                return responder
            }
        }
        return nil
    }
}

// MARK: - UIView Helper

private extension UIView {
    func findSuperview<T: UIView>(of type: T.Type) -> T? {
        return superview as? T ?? superview?.findSuperview(of: type)
    }
}

// MARK: - UIApplication Helper (iOS 13 - iOS 18 safe)

private extension UIApplication {
    var activeWindow: UIWindow? {
        if #available(iOS 15.0, *) {
            return connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .first
        } else {
            return windows.first { $0.isKeyWindow }
        }
    }
}
