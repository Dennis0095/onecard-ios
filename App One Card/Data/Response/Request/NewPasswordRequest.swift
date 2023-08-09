//
//  NewPasswordRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 8/08/23.
//

import Foundation

struct NewPasswordRequest: BaseRequest {
    let otpId: String
    let documentType: String
    let documentNumber: String
    let companyRUC: String
    let newPassword: String
    let confirmNewPassword: String
    
    enum CodingKeys: String, CodingKey {
        case otpId = "ID_OTP"
        case documentType = "TIPO_DOCUMENTO"
        case documentNumber = "NUMERO_DOCUMENTO"
        case companyRUC = "RUC_EMPRESA"
        case newPassword = "NUEVA_CLAVE"
        case confirmNewPassword = "CONFIRM_NUEVA_CLAVE"
    }
}
