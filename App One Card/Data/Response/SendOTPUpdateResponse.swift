//
//  SendOTPUpdateResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/07/23.
//

import Foundation

struct SendOTPUpdateResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let sendOtpSms: String?
    let sendOtpEmail: String?
    let success: String?
    let otpId: String?
    let title: String?
    let message: String?
    let truncatedCellphone: String?
    let truncatedEmail: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case sendOtpSms = "ENVIO_OTP_SMS"
        case sendOtpEmail = "ENVIO_OTP_EMAIL"
        case success = "EXITO"
        case otpId = "ID_OTP"
        case title = "TITULO"
        case message = "MENSAJE"
        case truncatedCellphone = "TELEFONO_CELULAR_TRUNC"
        case truncatedEmail = "CORREO_ELECTRONICO_TRUNC"
    }
}
