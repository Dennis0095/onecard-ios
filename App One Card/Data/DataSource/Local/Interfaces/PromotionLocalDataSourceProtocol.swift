//
//  PromotionLocalDataSourceProtocol.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 13/06/24.
//

import Foundation

protocol PromotionLocalDataSourceProtocol {
    func saveCategories(categories: [PromotionCategory]?)
    func getCategories() -> [PromotionCategory]?
}
