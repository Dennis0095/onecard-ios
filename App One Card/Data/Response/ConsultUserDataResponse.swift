//
//  ConsultUserDataResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 25/07/23.
//

import Foundation

struct ConsultUserDataResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let name: String?
    let lastName: String?
    let birthday: String?
    let docType: String?
    let docNumber: String?
    let truncatedCellphone: String?
    var email: String?
    let companyRUC: String?
    var userName: String?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case name = "NOMBRES"
        case lastName = "APELLIDOS"
        case birthday = "FECHA_NACIMIENTO"
        case docType = "TIPO_DOC"
        case docNumber = "NUM_DOC"
        case truncatedCellphone = "TELEFONO_CELULAR_TRUNC"
        case email = "CORREO_ELECTRONICO"
        case companyRUC = "RUC_EMPRESA"
        case userName = "NOMBRE_USUARIO"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
