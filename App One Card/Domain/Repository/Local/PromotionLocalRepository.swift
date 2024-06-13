//
//  PromotionLocalRepository.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation
import Combine

protocol PromotionLocalRepository {
    func saveCategories(categories: [PromotionCategory]?)
    func getCategories() -> [PromotionCategory]?
    func resetCategories(beforeCategories: [PromotionCategory]) -> [PromotionCategory]
    func saveChoosedCategories(categories: [PromotionCategory])
    func getChoosedCategories() -> [CategoryFilterRequest]?
}
