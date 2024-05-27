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

    func retryGetCategories(request: BaseRequest, success: @escaping ([PromotionCategory]) -> Void, error: @escaping (APIError) -> Void) {
        let cancellable = dataSource.getCategories(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let err):
                    error(err)
                }
            }
            receiveValue: { [weak self] response in
                guard let self = self else { return }
                if let categories = response.toPromotionCategories().categories {
                    localDataSource.saveCategories(categories: categories)
                    success(categories)
                } else {
                    error(APIError.defaultError)
                }
            }
        cancellable.store(in: &cancellables)
    }
}
