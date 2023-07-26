//
//  ConsultUserDataRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 25/07/23.
//

import Foundation

struct ConsultUserDataRequest: BaseRequest {
    let authTrackingCode: String
    
    enum CodingKeys: String, CodingKey {
        case authTrackingCode = "COD_SEG_AUTH"
    }
}
