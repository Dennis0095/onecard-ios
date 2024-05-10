//
//  LogoutResponse.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 9/05/24.
//

import Foundation

struct LogoutResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let success: String?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case success = "EXITO"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
