//
//  MovementResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 3/07/23.
//

import Foundation

struct MovementResponse: Codable {
    let date: String?
    let hour: String?
    let amount: String?
    let amountSign: String?
    let trade: String?
    let tradeCategory: String?
    let sequence: String?
    let cost: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case date = "FECHA"
        case hour = "HORA"
        case amount = "MONTO"
        case amountSign = "SIGNO_MONTO"
        case trade = "COMERCIO"
        case tradeCategory = "CATEGORIA COMERCIO"
        case sequence = "SECUENCIA"
        case cost = "COSTO"
        case type = "TIPO"
    }
}
