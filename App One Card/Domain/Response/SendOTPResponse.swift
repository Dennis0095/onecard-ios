//
//  SendOTPResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Foundation

struct SendOTPResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let sendOtpSms: String?
    let sendOtpEmail: String?
    let success: String?
    let otpId: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case sendOtpSms = "ENVIO_OTP_SMS"
        case sendOtpEmail = "ENVIO_OTP_EMAIL"
        case success = "EXITO"
        case otpId = "ID_OTP"
    }
}
