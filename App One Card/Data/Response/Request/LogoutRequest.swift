//
//  LogoutRequest.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 9/05/24.
//

import Foundation

struct LogoutRequest: BaseRequest {
    let authTrackingCode: String
    
    enum CodingKeys: String, CodingKey {
        case authTrackingCode = "COD_SEG_AUTH"
    }
}
