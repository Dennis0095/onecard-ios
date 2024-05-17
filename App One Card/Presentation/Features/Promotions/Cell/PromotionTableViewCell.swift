//
//  PromotionTableViewCell.swift
//  App One Card
//
//  Created by Paolo Arambulo on 19/07/23.
//

import UIKit

class PromotionTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewSpace: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var imgPromotion: UIImageView!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPreviousPrice: UILabel!
    
    private let priceFormatter = NumberFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceFormatter.minimumIntegerDigits = 1
        priceFormatter.minimumFractionDigits = 2
        
        lblPrice.font = UIFont(name: "ProximaNova-Bold", size: 17)
        lblPreviousPrice.font = UIFont(name: "ProximaNova-Medium", size: 16)
        
        viewPrice.layer.cornerRadius = 5
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        self.addShadow(opacity: 0.08, offset: CGSize(width: 2, height: 4), radius: 8)
        
        imgPromotion.layer.masksToBounds = true
        imgPromotion.layer.cornerRadius = 10
    }
    
    func setData(promotion: PromotionResponse, isLast: Bool) {
        viewSpace.isHidden = isLast
        
        lblTitle.text = promotion.title
        lblContent.text = promotion.content
        imgPromotion.base64ToImage(base64String: promotion.image ?? "")
        validatePromotion(promotion: promotion)
    }
    
    private func validatePromotion(promotion: PromotionResponse) {
        viewPrice.isHidden = !(promotion.applyPrice == 1 || promotion.applyDiscount == 1)
        if promotion.applyPrice == 1 {
            let previousPrice = NSNumber(floatLiteral: promotion.previousPrice ?? 0.0)
            let price = NSNumber(floatLiteral: promotion.newPrice ?? 0.0)
            
            lblPreviousPrice.isHidden = false
            lblPreviousPrice.attributedText = "S/ \(priceFormatter.string(from: previousPrice)!)".strikeThrough()
            
            lblPrice.text = "S/ \(priceFormatter.string(from: price)!)"
            
            viewPrice.backgroundColor = #colorLiteral(red: 0, green: 0.2980392157, blue: 0.5921568627, alpha: 1)
        } else if promotion.applyDiscount == 1 {
            lblPreviousPrice.isHidden = true
            lblPreviousPrice.text = ""
            lblPreviousPrice.attributedText = nil
            
            lblPrice.text = "\(Int(promotion.discountRate ?? 0.0)) % DSCTO."
            
            viewPrice.backgroundColor = #colorLiteral(red: 0, green: 0.6392156863, blue: 0.8784313725, alpha: 1)
        } else {
            lblPreviousPrice.isHidden = true
            lblPreviousPrice.text = ""
            lblPreviousPrice.attributedText = nil
            
            lblPrice.text = ""
            
            viewPrice.backgroundColor = .clear
        }
    }

}
