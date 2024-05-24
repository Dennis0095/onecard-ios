//
//  PromotionSubCategory.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation

class PromotionSubCategory: Codable {
    var id: String?
    var name: String?
    
    var isChoosed: Bool = false
    
    init(id: String? = nil, name: String? = nil, isChoosed: Bool = false) {
        self.id = id
        self.name = name
        self.isChoosed = isChoosed
    }
}
