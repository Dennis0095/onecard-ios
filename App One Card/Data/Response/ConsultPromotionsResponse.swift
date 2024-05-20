//
//  ConsultPromotionsResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/07/23.
//

import Foundation

struct ConsultPromotionsResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let currentPromAmount: Int?
    let promotions: [PromotionResponse]?
    let totalPromotions: Int?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case currentPromAmount = "CANTIDAD_PROMO_VIGENTES"
        case totalPromotions = "TOTAL_PROMOCIONES"
        case promotions = "PROMOCIONES"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
