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
    let currentPromAmount: String?
    let promotions: [PromotionResponse]?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case currentPromAmount = "CANTIDAD_PROMO_VIGENTES"
        case promotions = "PROMOCIONES"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}


//"RC": "0",
//"RC_DESC": "TRANSACCIÓN OK",
//"CANTIDAD_PROMO_VIGENTES": "3",
//"PROMOCIONES": [
//    {
//        "CODIGO_PROMOCION": "1",
//        "IMAGEN_PROMOCION": "NAM2MTcyNzI3NTczNjU2Qw==",
//        "TITULO": "Duplica tus millas ClubMiles",
//        "CONTENIDO": "Pague en una cuota y solicite el fraccionamiento sin intereses en nuestra web."
//    },
//    {
//        "CODIGO_PROMOCION": "2",
//        "IMAGEN_PROMOCION": "NBM2MTcyNzI3NTczNjU2Qw==",
//        "TITULO": "Duplica tus millas ClubMiles",
//        "CONTENIDO": "Pague en una cuota y solicite el fraccionamiento sin intereses en nuestra web"
//    },
//    {
//        "CODIGO_PROMOCION": "3",
//        "IMAGEN_PROMOCION": "NBM2MTcyNzI3NTczNjU2Qw==",
//        "TITULO": "Duplica tus millas ClubMiles",
//        "CONTENIDO": "Pague en una cuota y solicite el fraccionamiento sin intereses en nuestra web."
//    }
//],
//"TITULO": null,
//"MENSAJE": null
