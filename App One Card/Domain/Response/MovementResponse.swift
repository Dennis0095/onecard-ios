//
//  MovementResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 3/07/23.
//

import Foundation

struct MovementResponse: Codable {
    let processDate: String?
    let transactionDate: String?
    let transactionHour: String?
    let currency: String?
    let amount: String?
    let sign: String?
    let traceNumber: String?
    let operationType: String?
    let transactionDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case processDate = "FECHA_PROCESO"
        case transactionDate = "FECHA_TRANSACCION"
        case transactionHour = "HORA_TRANSACCION"
        case currency = "MONEDA"
        case amount = "MONTO_2"
        case sign = "SIGNO"
        case traceNumber = "NUMERO_TRACE"
        case operationType = "TIPO_OPERACIÓN"
        case transactionDescription = "DESCRIPCION_TRANSACCION"
    }
}
