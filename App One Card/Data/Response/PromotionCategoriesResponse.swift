//
//  PromotionCategoriesResponse.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation

struct PromotionCategoriesResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let categories: [PromotionCategoryResponse]?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case categories = "CATEGORIAS"
        case title = "TITULO"
        case message = "MENSAJE"
    }
    
    func toPromotionCategories() -> PromotionCategories {
        return PromotionCategories(categories: self.categories?.map { $0.toPromotionCategory() } )
    }
}
