//
//  PromotionsDelegateDataSource.swift
//  App One Card
//
//  Created by Paolo Arambulo on 19/07/23.
//

import UIKit

class PromotionsDelegateDataSource: NSObject {
    
    private var viewModel: PromotionListViewModelProtocol

    init(viewModel: PromotionListViewModelProtocol) {
        self.viewModel = viewModel
    }
    
}

extension PromotionsDelegateDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionTableViewCell", for: indexPath) as? PromotionTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.item(at: indexPath.row)
        let isLast = viewModel.isLast(at: indexPath.row)
        cell.setData(promotion: item, isLast: isLast)
        
        return cell
    }
}

extension PromotionsDelegateDataSource: UITableViewDelegate {}
