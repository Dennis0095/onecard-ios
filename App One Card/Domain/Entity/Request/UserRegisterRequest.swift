//
//  UserRegisterRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 30/06/23.
//

import Foundation

struct UserRegisterRequest: BaseRequest {
    let otpId: String
    let documentType: String
    let documentNumber: String
    let companyRUC: String
    let username: String
    let password: String
    let password_ok: String
    
    enum CodingKeys: String, CodingKey {
        case otpId = "ID_OTP"
        case documentType = "TIPO_DOCUMENTO"
        case documentNumber = "NUMERO_DOCUMENTO"
        case companyRUC = "RUC_EMPRESA"
        case username = "NOMBRE_USUARIO"
        case password = "CONTRASENIA"
        case password_ok = "CONTRASENIA_OK"
    }
}
