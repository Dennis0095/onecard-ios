//
//  CardStatusRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 21/07/23.
//

import Foundation

struct CardStatusRequest: BaseRequest {
    let segCode: String
    
    enum CodingKeys: String, CodingKey {
        case segCode = "COD_SEG"
    }
}
