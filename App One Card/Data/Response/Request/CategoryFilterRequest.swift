//
//  CategoryFilterRequest.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 24/05/24.
//

import Foundation

struct CategoryFilterRequest: BaseRequest {
    let categoryId: String
    let subCategories: [String]
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "ID_CATEGORIA"
        case subCategories = "SUBCATEGORIAS"
    }
}
