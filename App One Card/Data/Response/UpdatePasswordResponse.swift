//
//  UpdatePasswordResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 1/08/23.
//

import Foundation

struct UpdatePasswordResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let matchNewPassword: String?
    let matchCurrentPassword: String?
    let formNewPassword: String?
    let validateNewPassword: String?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case matchNewPassword = "COINC_CLAVE_NUE_ACT"
        case matchCurrentPassword = "VALIDA_CLAVE_ACTUAL"
        case formNewPassword = "FORM_CLAVE_NUEVA"
        case validateNewPassword = "VALIDA_CLAVE_NUEVA"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
