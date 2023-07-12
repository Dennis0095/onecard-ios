//
//  BalanceInquiryRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 1/07/23.
//

import Foundation

struct BalanceInquiryRequest: BaseRequest {
    let segCode: String
    
    enum CodingKeys: String, CodingKey {
        case segCode = "CODIGO_SEG"
    }
}
