//
//  GeneralParametersResponse.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 9/05/24.
//

import Foundation

struct GeneralParametersResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let title: String?
    let message: String?
    let termsRegister: String?
    let termsDataTreatment: String?
    let termsRecovery: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case title = "TITULO"
        case message = "MENSAJE"
        case termsRegister = "ENLACE_TERMINOS_CONDICIONES_REGISTRO"
        case termsDataTreatment = "ENLACE_TERMINOS_TRATAMIENTO_DATOS_REGISTRO"
        case termsRecovery = "ENLACE_TERMINOS_CONDICIONES_RECUPERACION"
    }
}
