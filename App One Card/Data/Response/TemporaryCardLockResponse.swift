//
//  TemporaryCardLockResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import Foundation

struct TemporaryCardLockResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let otpMatchIndex: String?
    let lockCode: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case otpMatchIndex = "IND_COINCIDE_OTP"
        case lockCode = "CODIGO_BLOQUEO"
    }
}
