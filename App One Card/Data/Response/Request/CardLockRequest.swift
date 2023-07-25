//
//  CardLockRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import Foundation

struct CardLockRequest: BaseRequest {
    let otpId: String
    let otpCode: String
    let trackingCodeAuth: String
    let trackingCode: String
    let reason: String
    
    enum CodingKeys: String, CodingKey {
        case otpId = "ID_OTP"
        case otpCode = "CODIGO_OTP"
        case trackingCodeAuth = "COD_SEG_AUTH"
        case trackingCode = "COD_SEG"
        case reason = "MOTIVO"
    }
}
