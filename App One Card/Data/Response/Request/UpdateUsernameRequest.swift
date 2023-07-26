//
//  UpdateUsernameRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/07/23.
//

import Foundation

struct UpdateUsernameRequest: BaseRequest {
    let otpId: String
    let newUsername: String
    let beforeUsername: String
    let authTrackingCode: String
    
    enum CodingKeys: String, CodingKey {
        case otpId = "ID_OTP"
        case newUsername = "NOMBRE_USUARIO_NEW"
        case beforeUsername = "NOMBRE_USUARIO_ANT"
        case authTrackingCode = "COD_SEG_AUTH"
    }
}
