//
//  ConsultFrequentQuestionsResponse.swift
//  App One Card
//
//  Created by Paolo Arambulo on 18/08/23.
//

import Foundation

struct ConsultFrequentQuestionsResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let currentFreqQues: Int?
    let questions: [QuestionResponse]?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case currentFreqQues = "CANTIDAD_PREG_FREC"
        case questions = "PREGUNTAS"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
