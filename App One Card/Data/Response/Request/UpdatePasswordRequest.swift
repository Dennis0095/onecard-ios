//
//  UpdatePasswordRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 1/08/23.
//

import Foundation

struct UpdatePasswordRequest: BaseRequest {
    let authTrackingCode: String
    let currentPassword: String
    let newPassword: String
    let confirmNewPassword: String
    
    enum CodingKeys: String, CodingKey {
        case authTrackingCode = "COD_SEG_AUTH"
        case currentPassword = "CLAVE_ACTUAL"
        case newPassword = "CLAVE_NUEVA"
        case confirmNewPassword = "CONF_CLAVE_NUEVA"
    }
}
