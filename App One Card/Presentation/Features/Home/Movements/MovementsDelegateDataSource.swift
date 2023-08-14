//
//  MovementsDelegateDataSource.swift
//  App One Card
//
//  Created by Paolo Arambulo on 20/07/23.
//

import UIKit

class MovementsDelegateDataSource: NSObject {
    
    private var viewModel: MovementsViewModelProtocol

    init(viewModel: MovementsViewModelProtocol) {
        self.viewModel = viewModel
    }
    
}

extension MovementsDelegateDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovementTableViewCell", for: indexPath) as? MovementTableViewCell else {
            return UITableViewCell()
        }
        
        let movement = viewModel.items[indexPath.row]
        cell.setData(movement: movement)
        return cell
    }
}

extension MovementsDelegateDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movement = viewModel.items[indexPath.row]
        viewModel.selectItem(movement: movement)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
//        if offsetY > contentHeight - screenHeight * 2, !viewModel.isLoading {
//            viewModel.currentPage += 1
//            loadData() // Load more data when scrolled close to the bottom
//        }
        if offsetY > contentHeight - screenHeight * 2 {
            viewModel.consultMovements()
        }
    }
}
