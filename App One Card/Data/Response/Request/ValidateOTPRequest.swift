//
//  ValidateOTPRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 30/06/23.
//

import Foundation

struct ValidateOTPRequest: BaseRequest {
    let otpId: String
    let otpCode: String
    
    enum CodingKeys: String, CodingKey {
        case otpId = "ID_OTP"
        case otpCode = "CODIGO_OTP"
    }
}
