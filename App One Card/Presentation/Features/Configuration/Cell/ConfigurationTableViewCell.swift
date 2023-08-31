//
//  ConfigurationTableViewCell.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/06/23.
//

import UIKit

class ConfigurationTableViewCell: UITableViewCell {

    @IBOutlet weak var imgConfiguration: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewSeparator: UIView!
    
    var isLast: Bool = false {
        didSet {
            viewSeparator.isHidden = isLast
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(item: ConfigurationItem, isLast: Bool, image: UIImage) {
        self.isLast = isLast
        lblTitle.text = item.title
        imgConfiguration.image = image
    }
    
}
