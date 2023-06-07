//
//  Colors.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

class Design {
    static func color(_ color: ColorStyle) -> UIColor {
        switch color {
        case .light:
            return .white
        case .primary:
            return UIColor(hexString: "#28B4F5")
        case .accent:
            return UIColor(hexString: "#007AD1")
        case .dark1:
            return UIColor(hexString: "#00569F")
        case .dark2:
            return UIColor(hexString: "#003461")
        case .grey5:
            return UIColor(hexString: "#F6F6F6")
        case .grey20:
            return UIColor(hexString: "#DADBDB")
        case .grey40:
            return UIColor(hexString: "#B5B7B8")
        case .grey60:
            return UIColor(hexString: "#919394")
        case .grey80:
            return UIColor(hexString: "#6C6F71")
        case .grey100:
            return UIColor(hexString: "#474B4D")
        }
    }
}

enum ColorStyle {
    case light
    case primary
    case accent
    case dark1
    case dark2
    case grey5
    case grey20
    case grey40
    case grey60
    case grey80
    case grey100
}
