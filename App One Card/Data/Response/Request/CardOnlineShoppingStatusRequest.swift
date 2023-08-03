//
//  CardOnlineShoppingStatusRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 21/07/23.
//

import Foundation

struct CardOnlineShoppingStatusRequest: BaseRequest {
    let trackingCode: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case trackingCode = "COD_SEG"
        case type = "BTN_TIPO"
    }
}
