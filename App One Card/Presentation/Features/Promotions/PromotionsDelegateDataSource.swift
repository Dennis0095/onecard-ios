//
//  PromotionsDelegateDataSource.swift
//  App One Card
//
//  Created by Paolo Arambulo on 19/07/23.
//

import UIKit

class PromotionsDelegateDataSource: NSObject {
    
    private var viewModel: PromotionsViewModelProtocol

    init(viewModel: PromotionsViewModelProtocol) {
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

extension PromotionsDelegateDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.item(at: indexPath.row)
        
        viewModel.getDetail(promotionCode: item.promotionCode ?? "")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tableViewContentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.height
        let scrollOffset = scrollView.contentOffset.y

        if scrollOffset + tableViewHeight >= tableViewContentHeight, !viewModel.isLoadingPage {
            viewModel.paginate()
        }
    }
}
