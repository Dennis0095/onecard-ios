//
//  LoginRequest.swift
//  App One Card
//
//  Created by Paolo Arambulo on 15/07/23.
//

import Foundation

struct LoginRequest: BaseRequest {
    let user: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case user = "USUARIO"
        case password = "PASSWORD"
    }
}
