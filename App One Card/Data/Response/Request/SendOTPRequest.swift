//
//  SendOTPRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Foundation

struct SendOTPRequest: BaseRequest {
    let otpShippingType: String
    let cellPhone: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case otpShippingType = "TIPO_ENVIO_OTP"
        case cellPhone = "TELEFONO_CELULAR"
        case email = "CORREO_ELECTRONICO"
    }
}
