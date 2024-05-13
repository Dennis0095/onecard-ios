//
//  PromotionDetailResponse.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 13/05/24.
//

import Foundation

struct PromotionDetailResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let found: Int?
    let title: String?
    let message: String?
    
    let promotionCode: String?
    let promotionImage: String?
    let promotionTitle: String?
    let content: String?
    let detailTitle: String?
    let detailSubtitle: String?
    let applyPrice: Int?
    let applyDiscount: Int?
    let price: Double?
    let discountRate: Double?
    let detailDescription: String?
    let exchangePlace: String?
    let termsConditions: String?
    let validity: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case found = "ENCONTRADO"
        case title = "TITULO"
        case message = "MENSAJE"
        
        case promotionCode = "CODIGO_PROMOCION"
        case promotionImage = "IMAGEN_PROMOCION"
        case promotionTitle = "TITULO_PROMOCION"
        case content = "CONTENIDO"
        case detailTitle = "TITULO_DETALLE"
        case detailSubtitle = "SUB_TITULO_DETALLE"
        case applyPrice = "APLICA_PRECIO"
        case applyDiscount = "APLICA_DESCUENTO"
        case price = "MONTO_PRECIO"
        case discountRate = "PORCENTAJE_DESCUENTO"
        case detailDescription = "DESCRIPCION_DETALLE"
        case exchangePlace = "LUGAR_CANJE"
        case termsConditions = "TERMINOS_Y_CONDICIONES"
        case validity = "FECHA_VIGENCIA"
    }
}
