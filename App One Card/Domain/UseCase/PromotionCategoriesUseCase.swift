//
//  PromotionCategoriesUseCase.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation
import Combine

protocol PromotionCategoriesUseCaseProtocol {
    func getCategories(request: BaseRequest)
    func retryGetCategories(request: BaseRequest, success: @escaping (_ categories: [PromotionCategory]) -> Void)
    func getCategories() -> [PromotionCategory]?
    func resetCategories() -> [PromotionCategory]
    func saveChoosedCategories(categories: [PromotionCategory])
    func getChoosedCategories() -> [CategoryFilterRequest]?
}

class PromotionCategoriesUseCase: PromotionCategoriesUseCaseProtocol {
    private let repository: PromotionCategoriesRepository
    private let localRepository: PromotionCategoriesLocalRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: PromotionCategoriesRepository,
         localRepository: PromotionCategoriesLocalRepository) {
        self.repository = repository
        self.localRepository = localRepository
    }
    
    func getCategories(request: BaseRequest) {
        repository.getCategories(request: request)
    }
    
    func retryGetCategories(request: BaseRequest, success: @escaping (_ categories: [PromotionCategory]) -> Void) {
        return repository.retryGetCategories(request: request, success: success)
    }
    
    func getCategories() -> [PromotionCategory]? {
        return localRepository.getCategories()
    }
    
    func resetCategories() -> [PromotionCategory] {
        localRepository.resetCategories()
    }
    
    func saveChoosedCategories(categories: [PromotionCategory]) {
        localRepository.saveChoosedCategories(categories: categories)
    }
    
    func getChoosedCategories() -> [CategoryFilterRequest]? {
        localRepository.getChoosedCategories()
    }
}
