//
//  ValidateKeyRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Foundation

struct ValidateKeyRequest: BaseRequest {
    let segCode: String
    let pin: String
    let tLocal: String
    
    enum CodingKeys: String, CodingKey {
        case segCode = "COD_SEG"
        case pin = "PIN"
        case tLocal = "TLOCAL"
    }
}
