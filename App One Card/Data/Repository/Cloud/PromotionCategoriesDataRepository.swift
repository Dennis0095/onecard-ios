//
//  PromotionCategoriesDataRepository.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation
import Combine

class PromotionCategoriesDataRepository: PromotionCategoriesRepository {
    
    private let dataSource: PromotionsCategoriesDataSource
    private let localDataSource: PromotionsCategoriesLocalDataSource
    private var cancellables = Set<AnyCancellable>()
    
    init(dataSource: PromotionsCategoriesDataSource,
         localDataSource: PromotionsCategoriesLocalDataSource) {
        self.dataSource = dataSource
        self.localDataSource = localDataSource
    }
    
    func getCategories(request: BaseRequest) {
        let cancellable = dataSource.getCategories(request: request)
            .sink { _ in }
            receiveValue: { [weak self] response in
                guard let self = self else { return }
                let categories = response.toPromotionCategories().categories
                self.localDataSource.saveCategories(categories: categories)
            }
        cancellable.store(in: &cancellables)
    }
    
    func retryGetCategories(request: BaseRequest, success: @escaping (_ categories: [PromotionCategory]) -> Void) {
        let cancellable = dataSource.getCategories(request: request)
            .sink { _ in }
            receiveValue: { [weak self] response in
                guard let self = self else { return }
                if let categories = response.toPromotionCategories().categories {
                    localDataSource.saveCategories(categories: categories)
                    success(categories)
                }
            }
        cancellable.store(in: &cancellables)
    }
}
