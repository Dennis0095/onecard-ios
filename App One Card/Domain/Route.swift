//
//  Route.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/06/23.
//

import Foundation

enum Route {
    case validateUser
    
    var description: String {
        switch self {
        case .validateUser:
            return "/validateUser"
        }
    }
}
