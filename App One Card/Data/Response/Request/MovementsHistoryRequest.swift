//
//  MovementsHistoryRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/08/23.
//

import Foundation

struct MovementsHistoryRequest: BaseRequest {
    let trackingCode: String
    let pageSize: String
    let page: String
    
    enum CodingKeys: String, CodingKey {
        case trackingCode = "COD_SEG"
        case pageSize = "TAMANIO_PAG"
        case page = "PAGINA"
    }
}
