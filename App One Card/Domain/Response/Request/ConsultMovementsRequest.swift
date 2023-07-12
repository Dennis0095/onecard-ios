//
//  ConsultMovementsRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 2/07/23.
//

import Foundation

struct ConsultMovementsRequest: BaseRequest {
    let segCode: String
    
    enum CodingKeys: String, CodingKey {
        case segCode = "COD_SEG"
    }
}
