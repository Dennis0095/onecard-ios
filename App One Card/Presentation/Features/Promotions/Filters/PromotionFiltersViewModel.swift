//
//  PromotionFiltersViewModel.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation

protocol PromotionFiltersViewModelProtocol {
    func applyFilters()
    func clearFilters()
    func expandedSection(section: Int)
    func chooseSubCategory(indexPath: IndexPath)
    
    func category(at index: Int) -> PromotionCategory
    func subCategory(indexPath: IndexPath) -> PromotionSubCategory
    func isExpanded(section: Int) -> Bool
    func numberOfSections() -> Int
    func numberOfItemsBySection(section: Int) -> Int
    func moveScroll()
}

protocol PromotionFiltersViewModelDelegate {
    func expandedSection(section: Int)
    func movingScrollView()
    func clearFilters()
}

class PromotionFiltersViewModel: PromotionFiltersViewModelProtocol {
    
    private let fetchUseCase: FetchPromotionCategoriesUseCaseProtocol
    private let resetUseCase: ResetPromotionCategoriesUseCaseProtocol
    private let saveChooseUseCase: SaveChoosedPromotionCategoriesUseCaseProtocol
    private var categories: [PromotionCategory]
    
    var delegate: PromotionFiltersViewModelDelegate?
    
    init(fetchUseCase: FetchPromotionCategoriesUseCaseProtocol,
         resetUseCase: ResetPromotionCategoriesUseCaseProtocol,
         saveChooseUseCase: SaveChoosedPromotionCategoriesUseCaseProtocol,
         categories: [PromotionCategory]) {
        self.fetchUseCase = fetchUseCase
        self.resetUseCase = resetUseCase
        self.saveChooseUseCase = saveChooseUseCase
        self.categories = categories
    }
    
    func numberOfSections() -> Int {
        return categories.count
    }
    
    func numberOfItemsBySection(section: Int) -> Int {
        return categories[section].subCategories?.count ?? 0
    }
    
    func category(at index: Int) -> PromotionCategory {
        return categories[index]
    }
    
    func subCategory(indexPath: IndexPath) -> PromotionSubCategory {
        return (categories[indexPath.section].subCategories ?? [])[indexPath.row]
    }
    
    func chooseSubCategory(indexPath: IndexPath) {
        (categories[indexPath.section].subCategories ?? [])[indexPath.row].isChoosed = !(categories[indexPath.section].subCategories ?? [])[indexPath.row].isChoosed
    }
    
    func isExpanded(section: Int) -> Bool {
        return categories[section].isExpanded
    }
    
    func applyFilters() {
        saveChooseUseCase.execute(categories: categories)
        delegate?.clearFilters()
    }
    
    func clearFilters() {
        self.categories = resetUseCase.execute(beforeCategories: self.categories)
        delegate?.clearFilters()
    }

    func expandedSection(section: Int) {
        categories[section].isExpanded = !categories[section].isExpanded
        delegate?.expandedSection(section: section)
    }
    
    func moveScroll() {
        delegate?.movingScrollView()
    }
    
}
