//
//  ConsultFrequentQuestionsRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 18/08/23.
//

import Foundation

struct ConsultFrequentQuestionsRequest: BaseRequest {
    let authTrackingCode: String
    
    enum CodingKeys: String, CodingKey {
        case authTrackingCode = "COD_SEG_AUTH"
    }
}
