//
//  ValidateOTPUpdateRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/07/23.
//

import Foundation

struct ValidateOTPUpdateRequest: BaseRequest {
    let otpId: String
    let otpCode: String
    let operationType: String
    let authTrackingCode: String
    
    enum CodingKeys: String, CodingKey {
        case otpId = "ID_OTP"
        case otpCode = "CODIGO_OTP"
        case operationType = "TIPO_OPERACION"
        case authTrackingCode = "COD_SEG_AUTH"
    }
}
