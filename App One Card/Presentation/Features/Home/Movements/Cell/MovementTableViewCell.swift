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
            let amount = m.amount?.parseAmountToCurrency(type: m.currency ?? "", sign: m.sign ?? "") ?? ""
            lblAmount.textColor = m.sign == "D" ? #colorLiteral(red: 0.4235294118, green: 0.4352941176, blue: 0.4431372549, alpha: 1) : #colorLiteral(red: 0, green: 0.337254902, blue: 0.6235294118, alpha: 1)
            lblAmount.text = amount
        }
    }
}
