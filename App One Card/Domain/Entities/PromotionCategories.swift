//
//  PromotionCategories.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation

class PromotionCategories: Codable {
    var categories: [PromotionCategory]?
    
    init(categories: [PromotionCategory]? = nil) {
        self.categories = categories
    }
}
