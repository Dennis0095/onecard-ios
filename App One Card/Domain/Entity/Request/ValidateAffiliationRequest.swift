//
//  ValidateAffiliationRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Foundation

struct ValidateAffiliationRequest: BaseRequest {
    let documentType: String
    let documentNumber: String
    let companyRUC: String
    
    enum CodingKeys: String, CodingKey {
        case documentType = "TIPO_DOCUMENTO"
        case documentNumber = "NUMERO_DOCUMENTO"
        case companyRUC = "RUC_EMPRESA"
    }
}
