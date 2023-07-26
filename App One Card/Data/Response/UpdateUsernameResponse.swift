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
    let existsEmail: String?
    let success: String?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case existsEmail = "EXISTE_EMAIL"
        case success = "EXITO"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
