//
//  ChangeCardOnlineShoppingStatusRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import Foundation

struct ChangeCardOnlineShoppingStatusRequest: BaseRequest {
    let trackingCode: String
    let type: String
    let action: String
    
    enum CodingKeys: String, CodingKey {
        case trackingCode = "COD_SEG"
        case type = "BTN_TIPO"
        case action = "BTN_ACN"
    }
}
