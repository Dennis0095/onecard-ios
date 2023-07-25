//
//  ConsultMovementsResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 2/07/23.
//

import Foundation

struct ConsultMovementsResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let quantity: String?
    let clientMovements: [MovementResponse]?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case quantity = "CANTIDAD"
        case clientMovements = "MOVIMIENTOS_CLIENTE"
    }
}
