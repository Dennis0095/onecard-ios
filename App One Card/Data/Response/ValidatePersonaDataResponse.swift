//
//  ValidatePersonaDataResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 28/06/23.
//

import Foundation

struct ValidatePersonaDataResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let exists: Int?
    let title: String?
    let message: String?
    let validExpiration: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case exists = "EXISTE"
        case title = "TITULO"
        case message = "MENSAJE"
        case validExpiration = "VALIDA_EXPIRACION"
    }
}
