//
//  ValidatePersonalDataRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 28/06/23.
//

import Foundation

struct ValidatePersonalDataRequest: BaseRequest {
    let documentType: String
    let documentNumber: String
    let companyRUC: String
    let name: String
    let lastName: String
    let birthday: String
    let cellphone: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case documentType = "TIPO_DOCUMENTO"
        case documentNumber = "NUMERO_DOCUMENTO"
        case companyRUC = "RUC_EMPRESA"
        case name = "NOMBRES_THB"
        case lastName = "APELLIDOS_THB"
        case birthday = "FECHA_NACIMIENTO"
        case cellphone = "TELEFONO_CELULAR"
        case email = "CORREO_ELECTRONICO"
    }
}
