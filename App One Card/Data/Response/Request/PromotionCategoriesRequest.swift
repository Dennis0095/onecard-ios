//
//  PromotionCategoriesRequest.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation

struct PromotionCategoriesRequest: BaseRequest {
    let authTrackingCode: String
    
    enum CodingKeys: String, CodingKey {
        case authTrackingCode = "COD_SEG_AUTH"
    }
}
