//
//  LoaderDisplaying.swift
//  App One Card
//
//  Created by Paolo Arambulo on 16/07/23.
//

import UIKit

protocol LoaderDisplaying {
    func showLoader()
    func hideLoader()
    func showError(title: String, description: String, onAccept: VoidActionHandler?)
}

extension LoaderDisplaying where Self:UIViewController {
    
    func showLoader() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                let loadingView = Loading(frame: window.bounds)
                window.addSubview(loadingView)
            }
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                for view in window.subviews {
                    if let loadingView = view as? Loading {
                        loadingView.dismiss()
                        break
                    }
                }
            }
        }
    }
    
    func showError(title: String, description: String, onAccept: VoidActionHandler?) {
        DispatchQueue.main.async {
            let view = AlertErrorViewController()
            view.titleError = title
            view.descriptionError = description
            view.accept = onAccept
            view.modalPresentationStyle = .overFullScreen
            view.modalTransitionStyle = .crossDissolve
            self.present(view, animated: true, completion: nil)
        }
    }

}
