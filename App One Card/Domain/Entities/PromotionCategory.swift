//
//  PromotionCategory.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation

class PromotionCategory: Codable {
    var id: String?
    var name: String?
    var subCategories: [PromotionSubCategory]?
    
    var isExpanded: Bool = false
    
    init(id: String? = nil, name: String? = nil, subCategories: [PromotionSubCategory]? = nil, isExpanded: Bool = false) {
        self.id = id
        self.name = name
        self.subCategories = subCategories
        self.isExpanded = isExpanded
    }
}
