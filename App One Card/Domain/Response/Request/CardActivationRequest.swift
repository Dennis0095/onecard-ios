//
//  CardActivationRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Foundation

struct CardActivationRequest: BaseRequest {
    let segCode: String
    
    enum CodingKeys: String, CodingKey {
        case segCode = "COD_SEG"
    }
}
