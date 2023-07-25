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
    var switchIsOn: Bool = false
    var listenChanges: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(configure: ConfigureResponse, isLast: Bool) {
        self.isLast = isLast
        lblTitle.text = configure.title
        
        if let _ = configure.message {
            lblDescription.text = configure.message
            lblDescription.isHidden = false
        }
        
        switchCell.setOn(configure.isOn ?? false, animated: true)
        
        if configure.enable ?? false {
            self.contentView.alpha = 1
            isUserInteractionEnabled = true
        } else {
            self.contentView.alpha = 0.35
            isUserInteractionEnabled = false
        }
    }
    
    @IBAction func switchCardConfigure(_ sender: UISwitch) {
        if sender.isOn {
            switchIsOn = true
            if let changes = listenChanges {
                changes(true)
            }
        } else {
            switchIsOn = false
            if let changes = listenChanges {
                changes(false)
            }
        }
    }
    
    
}
