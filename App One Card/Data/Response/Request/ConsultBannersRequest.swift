//
//  ConsultBannersRequest.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 6/03/24.
//

import Foundation

struct ConsultBannersRequest: BaseRequest {
    let authTrackingCode: String
    
    enum CodingKeys: String, CodingKey {
        case authTrackingCode = "COD_SEG_AUTH"
    }
}
