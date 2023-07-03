//
//  MovementsViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 2/07/23.
//

import UIKit

class MovementsViewModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    var movements: [MovementEntity]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movements?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovementTableViewCell", for: indexPath) as? MovementTableViewCell else {
            return UITableViewCell()
        }
        
        let movement = movements?[indexPath.row]
        cell.setData(movement: movement)
        return cell
    }
}
