//
//  UpdateEmailRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/07/23.
//

import Foundation

struct UpdateEmailRequest: BaseRequest {
    let otpId: String
    let newEmail: String
    let beforeEmail: String
    let authTrackingCode: String
    
    enum CodingKeys: String, CodingKey {
        case otpId = "ID_OTP"
        case newEmail = "CORREO_ELECTRONICO_NEW"
        case beforeEmail = "CORREO_ELECTRONICO_ANT"
        case authTrackingCode = "COD_SEG_AUTH"
    }
}
