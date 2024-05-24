//
//  PromotionCategoriesSessionManager.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation

protocol PromotionCategoriesSessionManagerProtocol {
    func saveCategories(categories: [PromotionCategory]?)
    func getCategories() -> [PromotionCategory]?
    func resetCategories(beforeCategories: [PromotionCategory]) -> [PromotionCategory]
    func saveChoosedCategories(categories: [PromotionCategory])
    func getChoosedCategories() -> [CategoryFilterRequest]?
}

class PromotionCategoriesSessionManager: PromotionCategoriesSessionManagerProtocol {
    
    static let shared = PromotionCategoriesSessionManager()
    
    private init() {}
    
    func saveCategories(categories: [PromotionCategory]?) {
        do {
            if let categories = categories {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(categories)
                UserDefaults.standard.set(jsonData, forKey: Constants.keyPromotionCategories)
                UserDefaults.standard.synchronize()
            }
        } catch {
            print(error)
        }
    }

    func getCategories() -> [PromotionCategory]? {
        if let jsonData = UserDefaults.standard.data(forKey: Constants.keyPromotionCategories) {
            let decoder = JSONDecoder()
            if let response = try? decoder.decode([PromotionCategory].self, from: jsonData) {
                return response
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func resetCategories(beforeCategories: [PromotionCategory]) -> [PromotionCategory] {
        let newList = beforeCategories.map {
            PromotionCategory(id: $0.id,
                              name: $0.name,
                              subCategories: $0.subCategories?.map { PromotionSubCategory(id: $0.id,
                                                                                         name: $0.name,
                                                                                         isChoosed: false) },
                              isExpanded: $0.isExpanded)
        }
        saveCategories(categories: newList)
        return newList
    }
    
    func saveChoosedCategories(categories: [PromotionCategory]) {
        saveCategories(categories: categories)
    }

    func getChoosedCategories() -> [CategoryFilterRequest]? {
        guard let categories = getCategories() else { return nil }
        
        return categories.compactMap { category in
            let choosedSubCategories = category.subCategories?.filter { $0.isChoosed } ?? []
            
            guard !choosedSubCategories.isEmpty else { return nil }
            
            return CategoryFilterRequest(categoryId: category.id ?? "",
                                         subCategories: choosedSubCategories.compactMap { $0.id }
            )
        }
    }
}
