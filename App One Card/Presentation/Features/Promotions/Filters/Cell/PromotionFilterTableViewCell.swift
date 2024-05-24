//
//  PromotionFilterTableViewCell.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 24/05/24.
//

import UIKit

class PromotionFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var btnChoose: UIButton!
    
    public var handleChoose: VoidActionHandler?
    
    func setData(subCategory: String, isChoosed: Bool) {
        lblSubCategory.text = subCategory
        btnChoose.setImage(isChoosed ? #imageLiteral(resourceName: "checkbox_checked.svg") : #imageLiteral(resourceName: "checkbox_unchecked.svg"), for: .normal)
    }

    @IBAction func choose(_ sender: Any) {
        if let action = handleChoose {
            action()
        }
    }
    
}
