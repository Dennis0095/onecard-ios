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
    @IBOutlet weak var imgPromotion: UIImageView!
    
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
        base64ToImage(base64String: promotion.image ?? "")
    }
    
    private func base64ToImage(base64String: String) {
        if let imageData = Data(base64Encoded: base64String) {
            // Create an UIImage from the Data
            if let image = UIImage(data: imageData) {
                // Now you have your image
                // You can display it, save it, or use it as needed
                imgPromotion.image = image
            } else {
                print("Error creating UIImage from Data")
            }
        }
    }
}
