//
//  CardStatusResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 21/07/23.
//

import Foundation

struct CardStatusResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case status = "ESTADO_TARJETA"
    }
}
