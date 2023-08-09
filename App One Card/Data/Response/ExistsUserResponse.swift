//
//  ExistsUserResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 8/08/23.
//

import Foundation

struct ExistsUserResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let exists: String?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case exists = "EXISTE"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
