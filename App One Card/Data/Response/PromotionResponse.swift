//
//  PromotionResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/07/23.
//

import Foundation

struct PromotionResponse: Codable {
    let promotionCode: String?
    let image: String?
    let title: String?
    let content: String?
    let applyPrice: Int?
    let applyDiscount: Int?
    let newPrice: Double?
    let previousPrice: Double?
    let discountRate: Double?
    
    enum CodingKeys: String, CodingKey {
        case promotionCode = "CODIGO_PROMOCION"
        case image = "IMAGEN_PROMOCION"
        case title = "TITULO"
        case content = "CONTENIDO"
        case applyPrice = "APLICA_PRECIO"
        case applyDiscount = "APLICA_DESCUENTO"
        case newPrice = "MONTO_PRECIO"
        case previousPrice = "MONTO_PRECIO_ANTIGUO"
        case discountRate = "PORCENTAJE_DESCUENTO"
    }
}
