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
    
    private func getAmountRealMovement(amount: String) -> String {
        if amount.count < 4 {
            return "0.00"
        }
        
        let amountConvert = amount.substring(to: amount.count - 2)
        let amountDecimal = amount.substring(from: (amount.count - 2))
        return "\(amountConvert).\(amountDecimal)"
    }
    
    func setData(movement: MovementResponse?) {
        if let m = movement {
            lblDescription.text = m.trade ?? ""
            lblDate.text = DateUtils.shared.parseDateToString(string: (m.date ?? "") + (m.hour ?? ""), format: "yyyyMMddHHmmss", outputFormat: "d MMM")
            let amount = getAmountRealMovement(amount: m.amount ?? "").convertStringToDecimalAndFormat(sign: m.amountSign ?? "")
            lblAmount.textColor = m.amountSign == "-" ? #colorLiteral(red: 0.4235294118, green: 0.4352941176, blue: 0.4431372549, alpha: 1) : #colorLiteral(red: 0, green: 0.337254902, blue: 0.6235294118, alpha: 1)
            lblAmount.text = amount
        }
    }
}
