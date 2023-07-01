//
//  ValidateOTPEntity.swift
//  App One Card
//
//  Created by Paolo Arambulo on 30/06/23.
//

import Foundation

struct ValidateOTPEntity: Codable {
    let rc: String?
    let rcDesc: String?
    let indexMatchOTP: String?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case indexMatchOTP = "IND_COINCIDE_OTP"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
