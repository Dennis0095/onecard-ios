//
//  ReassignKeyRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 1/08/23.
//

import Foundation

struct ReassignKeyRequest: BaseRequest {
    let operationId: String
    let trackingCode: String
    let pin: String
    let tLocal: String
    
    enum CodingKeys: String, CodingKey {
        case operationId = "ID_OPE"
        case trackingCode = "COD_SEG"
        case pin = "PIN"
        case tLocal = "TLOCAL"
    }
}
