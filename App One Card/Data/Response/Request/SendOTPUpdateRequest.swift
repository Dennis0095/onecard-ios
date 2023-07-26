//
//  SendOTPUpdateRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/07/23.
//

import Foundation

struct SendOTPUpdateRequest: BaseRequest {
    let otpShippingType: String
    let operationType: String
    let authTrackingCode: String
    
    enum CodingKeys: String, CodingKey {
        case otpShippingType = "TIPO_ENVIO_OTP"
        case operationType = "TIPO_OPERACION"
        case authTrackingCode = "COD_SEG_AUTH"
    }
}
