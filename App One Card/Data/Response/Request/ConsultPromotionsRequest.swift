//
//  ConsultPromotionsRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/07/23.
//

import Foundation

struct ConsultPromotionsRequest: BaseRequest {
    let trackingCode: String
    
    enum CodingKeys: String, CodingKey {
        case trackingCode = "COD_SEG"
    }
}
