//
//  LoginResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 15/07/23.
//

import Foundation

struct LoginResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let success: String?
    let token: String?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case success = "EXITO"
        case token = "TOKEN"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
