//
//  FrequentQuestionsDelegateDataSource.swift
//  App One Card
//
//  Created by Paolo Arambulo on 18/08/23.
//

import UIKit

class FrequentQuestionsDelegateDataSource: NSObject {
    
    private var viewModel: FrequentQuestionsViewModelProtocol

    init(viewModel: FrequentQuestionsViewModelProtocol) {
        self.viewModel = viewModel
    }
    
}

extension FrequentQuestionsDelegateDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FrequentQuestionsTableViewCell", for: indexPath) as? FrequentQuestionsTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.item(at: indexPath.row)
        let isLast = viewModel.isLast(at: indexPath.row)
        cell.setData(title: item.question ?? "", description: item.answer ?? "", isLast: isLast)
        
        cell.handleBreakDown = {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        return cell
    }
}

extension FrequentQuestionsDelegateDataSource: UITableViewDelegate {}

