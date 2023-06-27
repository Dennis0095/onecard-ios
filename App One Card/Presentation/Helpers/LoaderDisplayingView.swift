//
//  LoaderDisplayingView.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/06/23.
//

import UIKit

protocol LoaderDisplayingView: NSObjectProtocol {
    func showLoader()
    func hideLoader()
    //func showSnackBar(message: String, iconImage: UIImage, imgColorClose: UIImage, backgroundColor: UIColor, labelColor: UIColor, duration: TimeInterval)
}

extension LoaderDisplayingView where Self:UIViewController {
    func showLoader() {
        Loading.shared.show()
    }
    
    func hideLoader() {
        Loading.shared.hide()
    }
    
//    func showSnackBar(message: String, iconImage: UIImage, imgColorClose: UIImage, backgroundColor: UIColor, labelColor: UIColor, duration: TimeInterval) {
//        SnackbarManager.shared.showSnackbar(message: message, iconImage: iconImage, imgColorClose: imgColorClose, backgroundColor: backgroundColor, labelColor: labelColor, duration: duration)
//    }
}
