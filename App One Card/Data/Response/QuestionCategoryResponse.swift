//
//  QuestionCategoryResponse.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 17/05/24.
//

import Foundation

struct QuestionCategoryResponse: Codable {
    let name: String?
    var questions: [QuestionResponse]?
    
    enum CodingKeys: String, CodingKey {
        case name = "NOMBRE"
        case questions = "PREGUNTAS"
    }
}
