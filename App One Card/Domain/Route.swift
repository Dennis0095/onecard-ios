//
//  Route.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/06/23.
//

import Foundation

enum Route {
    case validateAffiliation
    case sendOTP
    case validateOTP
    
    var description: String {
        switch self {
        case .validateAffiliation:
            return "/dcp-app/backend/api/rest/txn-mix-admin/validar-afiliacion-thb"
        case .sendOTP:
            return "/dcp-app/backend/api/rest/txn-mix-admin/enviar-otp"
        case .validateOTP:
            return "/dcp-app/backend/api/rest/txn-mix-admin/validar-otp"
        }
    }
}
