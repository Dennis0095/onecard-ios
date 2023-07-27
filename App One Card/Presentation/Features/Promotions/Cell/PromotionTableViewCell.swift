//
//  PromotionTableViewCell.swift
//  App One Card
//
//  Created by Paolo Arambulo on 19/07/23.
//

import UIKit

class PromotionTableViewCell: UITableViewCell {

    @IBOutlet weak var viewSpace: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(promotion: PromotionResponse, isLast: Bool) {
        viewSpace.isHidden = isLast
        
        lblTitle.text = promotion.title
        lblContent.text = promotion.content
    }
    
}
