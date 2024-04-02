//
//  BalanceInquiryResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 1/07/23.
//

import Foundation

struct BalanceInquiryResponse: Codable {
    let rc: String?
    let rcDescription: String?
    let description: String?
    let currency: String?
    let amount: String?
    let sign: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDescription = "RC_DESC"
        case description = "DESCRIPCION"
        case currency = "MONEDA"
        case amount = "MONTO_2"
        case sign = "SIGNO"
    }
}
