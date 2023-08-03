//
//  ConsultPromotionsRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/07/23.
//

import Foundation

struct ConsultPromotionsRequest: BaseRequest {
    let authTrackingCode: String
    
    enum CodingKeys: String, CodingKey {
        case authTrackingCode = "COD_SEG_AUTH"
    }
}
