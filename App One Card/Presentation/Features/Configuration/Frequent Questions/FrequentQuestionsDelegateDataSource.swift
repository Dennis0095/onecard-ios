//
//  FrequentQuestionsDelegateDataSource.swift
//  App One Card
//
//  Created by Paolo Arambulo on 18/08/23.
//

import UIKit

class FrequentQuestionsDelegateDataSource: NSObject {
    
    private var viewModel: FrequentQuestionsViewModelProtocol
    private var indexsToExpanded = [IndexPath]()

    init(viewModel: FrequentQuestionsViewModelProtocol) {
        self.viewModel = viewModel
    }
    
}

extension FrequentQuestionsDelegateDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsBySection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FrequentQuestionsTableViewCell", for: indexPath) as? FrequentQuestionsTableViewCell else {
            return UITableViewCell()
        }
        
        let index = IndexPath(row: indexPath.row, section: indexPath.section)
        let item = viewModel.question(indexPath: index)
        let isExpanded = indexsToExpanded.isEmpty ? false : indexsToExpanded.filter { $0 == index }.isEmpty ? false : true
        
        cell.setData(title: item.question ?? "", description: item.answer ?? "", isExpanded: isExpanded)
        
        cell.handleBreakDown = {
            if self.indexsToExpanded.isEmpty {
                self.indexsToExpanded.append(index)
            } else {
                if let i = self.indexsToExpanded.firstIndex(of: index) {
                    self.indexsToExpanded.remove(at: i)
                } else {
                    self.indexsToExpanded.append(index)
                }
            }

            tableView.beginUpdates()
            tableView.reloadRows(at: [index], with: .automatic)
            tableView.endUpdates()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FrequentQuestionsHeaderTableViewCell") as? FrequentQuestionsHeaderTableViewCell else {
            return UIView()
        }
        
        let item = viewModel.category(at: section)
        header.lblTitle.text = item.name
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FrequentQuestionsDelegateDataSource: UITableViewDelegate {}

