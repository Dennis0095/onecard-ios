//
//  MovementsViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 2/07/23.
//

import UIKit

protocol MovementsViewModelProtocol {
    var items: [MovementResponse] { get set }
    
    func numberOfItems() -> Int
    func item(at index: Int) -> MovementResponse
    func isLast(at index: Int) -> Bool
}

class MovementsViewModel: MovementsViewModelProtocol {
    
    var items: [MovementResponse] = []
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(at index: Int) -> MovementResponse {
        return items[index]
    }
    
    func isLast(at index: Int) -> Bool {
        return (items.count - 1) == index
    }
    
}
