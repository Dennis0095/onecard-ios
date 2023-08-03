//
//  CardStatusRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 21/07/23.
//

import Foundation

struct CardStatusRequest: BaseRequest {
    let trackingCode: String
    
    enum CodingKeys: String, CodingKey {
        case trackingCode = "COD_SEG"
    }
}
