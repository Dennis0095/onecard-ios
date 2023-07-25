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
    let otpMatchIndex: String?
    let title: String?
    let message: String?
    let lockCode: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case otpMatchIndex = "IND_COINCIDE_OTP"
        case title = "TITULO"
        case message = "MENSAJE"
        case lockCode = "CODIGO_BLOQUEO"
    }
}
