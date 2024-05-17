//
//  UserRecoveryRequest.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 17/05/24.
//

import Foundation

struct UserRecoveryRequest: BaseRequest {
    let otpId: String
    let documentType: String
    let documentNumber: String
    let companyRUC: String
    
    enum CodingKeys: String, CodingKey {
        case otpId = "ID_OTP"
        case documentType = "TIPO_DOCUMENTO"
        case documentNumber = "NUMERO_DOCUMENTO"
        case companyRUC = "RUC_EMPRESA"
    }
}
