//
//  ValidateKeyResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Foundation

struct ValidateKeyResponse: Codable {
    let rc: String?
    let rcDesc: String??
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
    }
}
