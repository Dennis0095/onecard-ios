//
//  Route.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/06/23.
//

import Foundation

enum Route {
    case consultMovements
    case balanceInquiry
    case validateAffiliation
    case validatePersonalData
    case userRegister
    case sendOTP
    case validateOTP
    case validateKey
    case reassignKey
    case cardActivation
    
    var description: String {
        switch self {
        case .validateAffiliation:
            return "/dcp-app/backend/api/rest/txn-mix-admin/validar-afiliacion-thb"
        case .validatePersonalData:
            return "/dcp-app/backend/api/rest/txn-mix-admin/validar-datos-personales-thb"
        case .userRegister:
            return "/dcp-app/backend/api/rest/txn-mix-admin/registro-usuario-thb"
        case .sendOTP:
            return "/dcp-app/backend/api/rest/txn-mix-admin/enviar-otp"
        case .validateOTP:
            return "/dcp-app/backend/api/rest/txn-mix-admin/validar-otp"
        case .balanceInquiry:
            return "/dcp-app/simphub/api/rest/txn-admin/consulta-saldo"
        case .consultMovements:
            return "/dcp-app/simphub/api/rest/txn-admin/consulta-movimientos"
        case .validateKey:
            return "/dcp-app/simphub/api/rest/txn-admin/valida-clave"
        case .reassignKey:
            return "/dcp-app/simphub/api/rest/txn-admin/reasigna-clave"
        case .cardActivation:
            return "/dcp-app/simphub/api/rest/txn-admin/activacion-tarjeta"
        }
    }
}
