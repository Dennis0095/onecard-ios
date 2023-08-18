//
//  QuestionResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 18/08/23.
//

import Foundation

struct QuestionResponse: Codable {
    let questionCode: String?
    let question: String?
    let answer: String?
    
    enum CodingKeys: String, CodingKey {
        case questionCode = "CODIGO_PREGUNTA"
        case question = "PREGUNTA"
        case answer = "RESPUESTA"
    }
}
