//
//  UpdateUsernameResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/07/23.
//

import Foundation

struct UpdateUsernameResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let existsUser: String?
    let success: String?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case existsUser = "EXISTE_USUARIO"
        case success = "EXITO"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
