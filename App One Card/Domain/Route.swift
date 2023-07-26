//
//  Route.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/06/23.
//

import Foundation

enum Route {
    case login
    case consultMovements
    case balanceInquiry
    case validateAffiliation
    case validatePersonalData
    case userRegister
    case consultUserData
    case sendOTP
    case validateOTP
    case validateKey
    case reassignKey
    case cardActivation
    case cardStatus
    case cardOnlineShoppingStatus
    case cardLock
    case changeCardOnlineShoppingStatus
    case without
    
    var description: String {
        switch self {
        case .login:
            return "/txn-admin-auth/login"
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
            return "/dcp-app/simphubreader/api/rest/txn-admin/consulta-saldo"
        case .consultMovements:
            return "/dcp-app/simphubreader/api/rest/txn-admin/consulta-movimientos"
        case .validateKey:
            return "/dcp-app/simphubwriter/api/rest/txn-admin/valida-clave"
        case .reassignKey:
            return "/dcp-app/simphubwriter/api/rest/txn-admin/reasigna-clave"
        case .cardActivation:
            return "/dcp-app/simphubwriter/api/rest/txn-admin/activacion-tarjeta"
        case .cardStatus:
            return "/busqueda/txn-data/consulta-estado-tarjeta"
        case .cardOnlineShoppingStatus:
            return "/dcp-app/backend/api/rest/txn-mix-admin/consulta-boton-codseg"
        case .cardLock:
            return "/dcp-app/backend/api/rest/txn-mix-admin/bloqueo-tarjeta"
        case .changeCardOnlineShoppingStatus:
            return "/dcp-app/backend/api/rest/txn-mix-admin/boton-codseg"
        case .consultUserData:
            return "/txn-sec/consulta-datos-usuario"
        case .without:
            return ""
        }
    }
}
