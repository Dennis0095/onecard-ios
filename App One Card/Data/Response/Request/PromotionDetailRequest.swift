//
//  PromotionDetailRequest.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 13/05/24.
//

import Foundation

struct PromotionDetailRequest: BaseRequest {
    let authTrackingCode: String
    let promotionId: String
    
    enum CodingKeys: String, CodingKey {
        case authTrackingCode = "COD_SEG_AUTH"
        case promotionId = "ID_PROMOCION"
    }
}
