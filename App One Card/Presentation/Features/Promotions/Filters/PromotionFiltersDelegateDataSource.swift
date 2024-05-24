//
//  PromotionFiltersDelegateDataSource.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 24/05/24.
//

import UIKit

class PromotionFiltersDelegateDataSource: NSObject {
    
    private var viewModel: PromotionFiltersViewModelProtocol

    init(viewModel: PromotionFiltersViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    @objc
    private func handleChoose(sender: UIButton) {
        viewModel.expandedSection(section: sender.tag)
    }
    
}

extension PromotionFiltersDelegateDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isExpanded(section: section) ? viewModel.numberOfItemsBySection(section: section) : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionFilterTableViewCell", for: indexPath) as? PromotionFilterTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.subCategory(indexPath: indexPath)
        cell.setData(subCategory: item.name ?? "", isChoosed: item.isChoosed)
        
        cell.handleChoose = {
            self.viewModel.chooseSubCategory(indexPath: indexPath)
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableCell(withIdentifier: "PromotionFilterHeaderTableViewCell") as? PromotionFilterHeaderTableViewCell else {
            return nil
        }
        
        let item = viewModel.category(at: section)
        
        header.setData(category: item.name ?? "", isExpanded: item.isExpanded)
        header.btnBreakDown.tag = section
        header.btnBreakDown.addTarget(self, action: #selector(handleChoose(sender:)), for: .touchUpInside)
        
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}

extension PromotionFiltersDelegateDataSource: UITableViewDelegate {}
