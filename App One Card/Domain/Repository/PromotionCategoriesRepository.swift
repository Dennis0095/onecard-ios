//
//  PromotionCategoriesRepository.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation
import Combine

protocol PromotionCategoriesRepository {
    func getCategories(request: BaseRequest)
    func retryGetCategories(request: BaseRequest, success: @escaping (_ categories: [PromotionCategory]) -> Void)
}
