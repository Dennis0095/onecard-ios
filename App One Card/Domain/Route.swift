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
    case consultFrequentQuestions
    case movementsHistory
    case balanceInquiry
    case existsUser
    case validateAffiliation
    case validatePersonalData
    case userRegister
    case consultUserData
    case updateUsername
    case updateEmail
    case updatePassword
    case sendOTPRegister
    case sendOTPUpdate
    case validateOTPRegister
    case validateOTPUpdate
    case validateKey
    case reassignKey
    case cardActivation
    case cardStatus
    case cardOnlineShoppingStatus
    case cardLock
    case prepaidCardLock
    case changeCardOnlineShoppingStatus
    case consultPromotions
    case frequentQuestions
    case recoverPassword
    case without
    
    var description: String {
        switch self {
        case .login:
            return "/txn-admin-auth/login"
        case .existsUser:
            return "/txn-sec/existe-thb"
        case .validateAffiliation:
            return "/txn-admin-auth/afiliacion-thb"
        case .validatePersonalData:
            return "/txn-sec/registro-datos-personales-thb"
        case .userRegister:
            return "/txn-sec/registro-usuario-thb"
        case .sendOTPRegister:
            return "/txn-sec/envio-otp-doc"
        case .validateOTPRegister:
            return "/txn-sec/valida-otp-doc"
        case .sendOTPUpdate:
            return "/txn-sec/envio-otp"
        case .validateOTPUpdate:
            return "/txn-sec/valida-otp"
        case .balanceInquiry:
            return "/busqueda/txn-finan/consulta-saldo"
        case .consultMovements:
            return "/busqueda/txn-finan/consulta-movimientos"
        case .validateKey:
            return "/busqueda/txn-admin/valida-clave-app"
        case .reassignKey:
            return "/txn-admin/reasigna-clave-app"
        case .cardActivation:
            return "/txn-admin/activacion-tarjeta"
        case .cardStatus:
            return "/busqueda/txn-data/consulta-estado-tarjeta"
        case .cardOnlineShoppingStatus:
            return "/busqueda/txn-admin/consulta-boton-codseg"
        case .cardLock:
            return "/txn-admin/bloqueo-tarjeta"
        case .changeCardOnlineShoppingStatus:
            return "/txn-admin/boton-codseg"
        case .consultUserData:
            return "/txn-sec/consulta-datos-usuario"
        case .updateUsername:
            return "/txn-sec/actualizacion-nombre-usuario"
        case .consultPromotions:
            return "/busqueda/txn-data/consulta-promociones"
        case .updateEmail:
            return "/txn-sec/actualizacion-email"
        case .updatePassword:
            return "/txn-sec/cambio-contrasenia"
        case .prepaidCardLock:
            return "/txn-admin-tp/bloqueo-tarjeta"
        case .frequentQuestions:
            return "/busqueda/txn-data/consulta-preguntas-frecuentes"
        case .recoverPassword:
            return "/txn-sec/creacion-nueva-clave"
        case .movementsHistory:
            return "/busqueda/txn-finan/consulta-movimientos-hist"
        case .consultFrequentQuestions:
            return "/busqueda/txn-data/consulta-preguntas-frecuentes"
        case .without:
            return ""
        }
    }
}
