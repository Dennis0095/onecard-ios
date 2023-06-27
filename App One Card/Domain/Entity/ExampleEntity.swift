//
//  ExampleEntity.swift
//  App One Card
//
//  Created by Paolo Arambulo on 24/06/23.
//

import Foundation

struct ExampleEntity: Codable {
    let rc: String
    let rcDesc: String
    let existe: String
    let afiliado: String
    let codigoSeguimientoAuth: String
    let mensaje: String
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case existe = "EXISTE"
        case afiliado = "AFILIADO"
        case codigoSeguimientoAuth = "CODIGO_SEGUIMIENTO_AUTH"
        case mensaje = "MENSAJE"
    }
}
