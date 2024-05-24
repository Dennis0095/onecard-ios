//
//  PromotionCategoryResponse.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation

struct PromotionCategoryResponse: Codable {
    let id: String?
    let name: String?
    let subCategories: [PromotionSubCategoryResponse]?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID_CATEGORIA"
        case name = "NOMBRE_CATEGORIA"
        case subCategories = "SUBCATEGORIAS"
    }
    
    func toPromotionCategory() -> PromotionCategory {
        return PromotionCategory(id: self.id,
                                 name: self.name,
                                 subCategories: self.subCategories?.map { $0.toPromotionSubCategory() })
    }
}
