//
//  BaseViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 13/06/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    var baseScrollView: UIScrollView?
    var selectedTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        setActions()
        manageScroll()
        notificationKeyboard()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let _ = UserSessionManager.shared.getUser() else {
            return
        }
        
        (UIApplication.shared.delegate as! AppDelegate).resetTimer()
    }
    
    private func notificationKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let scrollView = baseScrollView, let activeTextField = self.selectedTextField {
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
            }
            
            let scrollViewBottomToView = self.view.safeAreaInsets.bottom
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height - scrollViewBottomToView, right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            let targetRect = activeTextField.convert(activeTextField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(targetRect, animated: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let scrollView = baseScrollView {
            let contentInsets = UIEdgeInsets.zero
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }

    func connectFields(textFields: UITextField...) {
        guard let lastTextField = textFields.last else {
            return
        }
        for i in 0 ..< textFields.count - 1 {
            if textFields[i].keyboardType == .numberPad || textFields[i].keyboardType == .decimalPad {
                addDoneButtonOnKeyboard(isLast: false, textfield: textFields[i], nextTextField: textFields[i+1])
            } else {
                textFields[i].returnKeyType = .next
                textFields[i].addTarget(textFields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
            }
        }
        if lastTextField.keyboardType == .numberPad || lastTextField.keyboardType == .decimalPad {
            addDoneButtonOnKeyboard(isLast: true, textfield: lastTextField)
        } else {
            lastTextField.returnKeyType = .done
            lastTextField.addTarget(lastTextField, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
        }
    }
    
    private func addDoneButtonOnKeyboard(isLast: Bool, textfield: UITextField, nextTextField: UITextField? = nil) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem()

        if isLast {
            done = UIBarButtonItem(title: "Aceptar", style: .done, target: textfield, action: #selector(UIResponder.resignFirstResponder))
        } else {
            done = UIBarButtonItem(title: "Siguiente", style: .done, target: nextTextField, action: #selector(UIResponder.becomeFirstResponder))
        }
        
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        textfield.inputAccessoryView = doneToolbar
    }
    
    open func initView() {}
    
    open func manageScroll() {}
    
    open func setActions() {}
}

extension BaseViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class BottomSheetPresentationController: UIPresentationController {
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        view.alpha = 0
        return view
    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect.zero }

        let safeAreaInsets = containerView.safeAreaInsets
        let presentedViewHeight = presentingViewController.view.frame.height

        return CGRect(x: 0, y: containerView.bounds.height - presentedViewHeight - safeAreaInsets.bottom,
                      width: containerView.bounds.width, height: presentedViewHeight)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideDimmingView))
        dimmingView.isUserInteractionEnabled = true
        dimmingView.addGestureRecognizer(tap)

        dimmingView.frame = containerView.bounds
        containerView.addSubview(dimmingView)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 1
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 0
        }, completion: { [weak self] _ in
            self?.dimmingView.removeFromSuperview()
        })
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    @objc func hideDimmingView() {
        self.presentedViewController.dismiss(animated: true)
    }
}
