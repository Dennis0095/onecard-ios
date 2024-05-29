//
//  MovementDetailViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 10/08/23.
//

import UIKit

class MovementDetailViewController: BaseViewController {
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblTrade: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblMovementNumber: UILabel!
    @IBOutlet weak var lblOperation: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    
    private var m: MovementResponse
    
    init(movement: MovementResponse) {
        self.m = movement
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        setData()
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
    }
    
    @objc
    private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getAmountRealMovement(amount: String) -> String {
        if amount.count < 3 {
            return "0.00"
        }
        
        let amountConvert = amount.substring(to: amount.count - 2)
        let amountDecimal = amount.substring(from: (amount.count - 2))
        return "\(amountConvert).\(amountDecimal)"
    }
    
    private func setData() {
        let amount = getAmountRealMovement(amount: m.amount ?? "").convertStringToDecimalAndFormat(sign: m.amountSign ?? "")
        lblAmount.textColor = m.amountSign == "-" ? #colorLiteral(red: 0.4235294118, green: 0.4352941176, blue: 0.4431372549, alpha: 1) : #colorLiteral(red: 0, green: 0.337254902, blue: 0.6235294118, alpha: 1)
        lblAmount.text = amount
        lblTrade.text = (m.trade ?? "").trimmingCharacters(in: .whitespaces)
        
        lblDate.text = DateUtils.shared.parseDateToString(string: m.date ?? "", format: "yyyyMMdd", outputFormat: "d MMM yyyy")
        
        lblHour.text = DateUtils.shared.parseDateToString(string: m.hour ?? "", format: "HHmmss", outputFormat: "h:mm a")
        
        lblMovementNumber.text = m.sequence ?? ""
        lblOperation.text = m.type ?? ""
    }
    
}
