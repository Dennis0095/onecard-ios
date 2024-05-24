//
//  PromotionFilterHeaderTableViewCell.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 24/05/24.
//

import UIKit

class PromotionFilterHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var btnBreakDown: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    func setData(category: String, isExpanded: Bool) {
        lblCategory.text = category
        btnBreakDown.setImage(!isExpanded ? #imageLiteral(resourceName: "arrow_down_blue.svg") : #imageLiteral(resourceName: "arrow_up_blue.svg"), for: .normal)
    }
    
}

