//
//  LoaderDisplaying.swift
//  App One Card
//
//  Created by Paolo Arambulo on 16/07/23.
//

import UIKit

protocol LoaderDisplaying {
    func showLoader()
    func hideLoader(onHide: VoidActionHandler?)
    func showError(title: String, description: String, onAccept: VoidActionHandler?)
    //func showSnackBar(message: String, iconImage: UIImage, imgColorClose: UIImage, backgroundColor: UIColor, labelColor: UIColor, duration: TimeInterval)
}

extension LoaderDisplaying where Self:UIViewController {
    func showLoader() {
        Loading.shared.show()
    }
    
    func hideLoader(onHide: VoidActionHandler?) {
        Loading.shared.hide {
            onHide?()
        }
    }
    
    func showError(title: String, description: String, onAccept: VoidActionHandler?) {
        let view = AlertErrorViewController()
        view.titleError = title
        view.descriptionError = description
        view.accept = onAccept
        view.modalPresentationStyle = .overFullScreen
        view.modalTransitionStyle = .crossDissolve
        self.present(view, animated: true, completion: nil)
    }
//    func showSnackBar(message: String, iconImage: UIImage, imgColorClose: UIImage, backgroundColor: UIColor, labelColor: UIColor, duration: TimeInterval) {
//        SnackbarManager.shared.showSnackbar(message: message, iconImage: iconImage, imgColorClose: imgColorClose, backgroundColor: backgroundColor, labelColor: labelColor, duration: duration)
//    }
}
