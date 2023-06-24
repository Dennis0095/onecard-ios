//
//  ConfigureCardTableViewCell.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/06/23.
//

import UIKit

class ConfigureCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var switchCell: UISwitch!
    @IBOutlet weak var lblDescription: UILabel!
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
    
    func configure(title: String, description: String? = nil, isLast: Bool) {
        self.isLast = isLast
        lblTitle.text = title
        
        if let _ = description {
            lblDescription.text = description
            lblDescription.isHidden = false
        }
    }
    
}
