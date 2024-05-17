//
//  UserRecoveryResponse.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 17/05/24.
//

import Foundation

struct UserRecoveryResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let success: String?
    let userName: String?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case success = "EXITO"
        case userName = "NOMBRE_USUARIO"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
