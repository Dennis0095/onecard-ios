//
//  SendOTPRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Foundation

struct SendOTPRequest: BaseRequest {
    let otpShippingType: String
    let operationType: String
    let documentType: String
    let documentNumber: String
    let companyRUC: String
    
    enum CodingKeys: String, CodingKey {
        case otpShippingType = "TIPO_ENVIO_OTP"
        case operationType = "TIPO_OPERACION"
        case documentType = "TIPO_DOCUMENTO"
        case documentNumber = "NUMERO_DOCUMENTO"
        case companyRUC = "RUC_EMPRESA"
    }
}
