//
//  MovementTableViewCell.swift
//  App One Card
//
//  Created by Paolo Arambulo on 2/07/23.
//

import UIKit

class MovementTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(movement: MovementEntity?) {
        if let m = movement {
            lblDescription.text = m.transactionDescription ?? ""
            lblDate.text = DateUtils.shared.parseDateToString(string: m.transactionDate ?? "", format: "yyyy-MM-dd", outputFormat: "d MMM")
            let amount = m.amount?.parseAmountToCurrency(type: m.currency ?? "") ?? ""
            lblAmount.text = "-\(amount)"
        }
    }
}
