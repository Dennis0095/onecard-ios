//
//  BalanceInquiryEntity.swift
//  App One Card
//
//  Created by Paolo Arambulo on 1/07/23.
//

import Foundation

struct BalanceInquiryEntity: Codable {
    let rc: String?
    let description: String?
    let currency: String?
    let amount: String?
    let sign: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case description = "DESCRIPCION"
        case currency = "MONEDA"
        case amount = "MONTO_2"
        case sign = "SIGNO"
    }
}
