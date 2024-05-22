//
//  ConsultPromotionsRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/07/23.
//

import Foundation

struct ConsultPromotionsRequest: BaseRequest {
    let authTrackingCode: String
    let pageSize: String
    let page: String
    let filter: String
    
    enum CodingKeys: String, CodingKey {
        case authTrackingCode = "COD_SEG_AUTH"
        case pageSize = "TAMANIO_PAG"
        case page = "PAGINA"
        case filter = "FILTRO_TEXTO"
    }
}
