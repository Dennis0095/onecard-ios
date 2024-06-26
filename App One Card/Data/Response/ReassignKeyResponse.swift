//
//  ReassignKeyResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Foundation

struct ReassignKeyResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let validExpiration: String?
    let success: String?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case validExpiration = "VALIDA_EXPIRACION"
        case success = "EXITO"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
