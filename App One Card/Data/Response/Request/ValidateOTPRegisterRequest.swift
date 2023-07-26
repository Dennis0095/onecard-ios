//
//  ValidateOTPRegisterRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 30/06/23.
//

import Foundation

struct ValidateOTPRegisterRequest: BaseRequest {
    let otpId: String
    let otpCode: String
    let operationType: String
    let documentType: String
    let documentNumber: String
    let companyRUC: String
    
    enum CodingKeys: String, CodingKey {
        case otpId = "ID_OTP"
        case otpCode = "CODIGO_OTP"
        case operationType = "TIPO_OPERACION"
        case documentType = "TIPO_DOCUMENTO"
        case documentNumber = "NUMERO_DOCUMENTO"
        case companyRUC = "RUC_EMPRESA"
    }
}
