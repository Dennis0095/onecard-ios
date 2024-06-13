//
//  FetchPromotionCategoriesUseCase.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 13/06/24.
//

import Foundation
import Combine

protocol FetchPromotionCategoriesUseCaseProtocol {
    func execute(request: PromotionCategoriesRequest, onLoading: @escaping () -> Void, onHideLoading: @escaping () -> Void, onSuccess: @escaping ([PromotionCategory]) -> Void, onError: @escaping (CustomError) -> Void)
}

class FetchPromotionCategoriesUseCase: FetchPromotionCategoriesUseCaseProtocol {
    
    private let cloudRepository: PromotionRepository
    private let localRepository: PromotionLocalRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(cloudRepository: PromotionRepository,
         localRepository: PromotionLocalRepository) {
        self.cloudRepository = cloudRepository
        self.localRepository = localRepository
    }
    
    func execute(request: PromotionCategoriesRequest, onLoading: @escaping () -> Void, onHideLoading: @escaping () -> Void, onSuccess: @escaping ([PromotionCategory]) -> Void, onError: @escaping (CustomError) -> Void) {
        
        if let categories = localRepository.getCategories() {
            onSuccess(categories)
        } else {
            onLoading()
            let cancellable = cloudRepository.getCategories(request: request)
                .sink { publisher in
                    onHideLoading()
                    
                    switch publisher {
                    case .finished: break
                    case .failure(let apiError):
                        let error = apiError.error()
                        onError(error)
                    }
                } receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    if let categories = response.toPromotionCategories() {
                        self.localRepository.saveCategories(categories: categories)
                        onSuccess(categories)
                    } else {
                        let error = APIError.defaultError.error()
                        onError(error)
                    }
                }
            cancellable.store(in: &cancellables)
        }
        
    }
}
