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
    
    enum CodingKeys: String, CodingKey {
        case promotionCode = "CODIGO_PROMOCION"
        case image = "IMAGEN_PROMOCION"
        case title = "TITULO"
        case content = "CONTENIDO"
    }
}
