//
//  CardLockRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import Foundation

struct CardLockRequest: BaseRequest {
    let trackingCode: String
    let reason: String
    
    enum CodingKeys: String, CodingKey {
        case trackingCode = "COD_SEG"
        case reason = "MOTIVO"
    }
}
