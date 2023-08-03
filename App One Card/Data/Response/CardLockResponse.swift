//
//  CardLockResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import Foundation

struct CardLockResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let lockCode: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case lockCode = "CODIGO_BLOQUEO"
    }
}
