//
//  ConfigureCardDelegateDataSource.swift
//  App One Card
//
//  Created by Paolo Arambulo on 21/07/23.
//

import UIKit

class ConfigureCardDelegateDataSource: NSObject {
    
    private var viewModel: ConfigureCardViewModelProtocol

    init(viewModel: ConfigureCardViewModelProtocol) {
        self.viewModel = viewModel
    }
    
}

extension ConfigureCardDelegateDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigureCardTableViewCell", for: indexPath) as? ConfigureCardTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setData(configure: viewModel.item(at: indexPath.row), isLast: viewModel.isLast(at: indexPath.row))
        cell.listenChanges = { [weak self] status in
            self?.viewModel.changeStatus(at: indexPath.row, status: status)
        }
        return cell
    }
}

extension ConfigureCardDelegateDataSource: UITableViewDelegate {}

