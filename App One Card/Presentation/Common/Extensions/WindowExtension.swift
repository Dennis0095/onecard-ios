//
//  WindowExtension.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

extension UIWindow {
//    static var key: UIWindow? {
//        if #available(iOS 13, *) {
//            return UIApplication.shared.windows.first { $0.isKeyWindow }
//        } else {
//            return UIApplication.shared.keyWindow
//        }
//    }
    
    func switchRootViewController(to viewController: UIViewController, animated: Bool = true) {
        guard animated else {
            rootViewController = viewController
            return
        }
        
        let pushTransition = CATransition()
        pushTransition.type = CATransitionType.push
        pushTransition.subtype = CATransitionSubtype.fromRight
        pushTransition.duration = 0.3
        pushTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
   
        self.layer.add(pushTransition, forKey: kCATransition)
        self.rootViewController = viewController
        self.makeKeyAndVisible()
    }
}
