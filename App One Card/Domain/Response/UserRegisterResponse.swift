//
//  UserRegisterResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 30/06/23.
//

import Foundation

struct UserRegisterResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let validUser: String?
    let validPassword: String?
    let confirmPassword: String?
    let validExpiration: String?
    let userExists: String?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case validUser = "VALIDA_USUARIO"
        case validPassword = "VALIDA_CONTRASENIA"
        case confirmPassword = "CONFIRMA_CONTRASENIA"
        case validExpiration = "VALIDA_EXPIRACION"
        case userExists = "EXISTENCIA_USUARIO"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
