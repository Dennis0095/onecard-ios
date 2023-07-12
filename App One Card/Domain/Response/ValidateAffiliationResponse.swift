//
//  ValidateAffiliationResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Foundation

struct ValidateAffiliationResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let affiliate: String?
    let exists: String?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case affiliate = "AFILIADO"
        case exists = "EXISTE"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
