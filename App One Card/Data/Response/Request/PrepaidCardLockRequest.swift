//
//  PrepaidCardLockRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import Foundation

struct PrepaidCardLockRequest: BaseRequest {
    let otpId: String
    let otpCode: String
    let authTrackingCode: String
    let trackingCode: String
    let reason: String
    
    enum CodingKeys: String, CodingKey {
        case otpId = "ID_OTP"
        case otpCode = "CODIGO_OTP"
        case authTrackingCode = "COD_SEG_AUTH"
        case trackingCode = "COD_SEG"
        case reason = "MOTIVO"
    }
}
