//
//  CardOnlineShoppingStatusResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 21/07/23.
//

import Foundation

struct CardOnlineShoppingStatusResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let status: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case status = "ESTADO_BOTON"
        case description = "DESCRIPCION"
    }
}
