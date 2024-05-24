//
//  PromotionSubCategoryResponse.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation

struct PromotionSubCategoryResponse: Codable {
    let id: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID_SUBCATEGORIA"
        case name = "NOMBRE_SUBCATEGORIA"
    }
    
    func toPromotionSubCategory() -> PromotionSubCategory {
        PromotionSubCategory(id: self.id,
                             name: self.name)
    }
}
