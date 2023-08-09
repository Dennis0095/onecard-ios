//
//  NewPasswordResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 8/08/23.
//

import Foundation

struct NewPasswordResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let indexNewPasswordFormat: String?
    let indexNewPasswordConfirm: String?
    let success: String?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case indexNewPasswordFormat = "IND_FORMATO_NUEVA_CLAVE"
        case indexNewPasswordConfirm = "IND_CONFIRM_NUEVA_CLAVE"
        case success = "EXITO"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
