//
//  FrequentQuestionsTableViewCell.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/06/23.
//

import UIKit

class FrequentQuestionsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var imgBreakDown: UIImageView!
    
    public var handleBreakDown: VoidActionHandler?
    
    var isLast: Bool = false {
        didSet {
            viewSeparator.isHidden = isLast
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addActions()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addActions() {
        let tapBreakDown = UITapGestureRecognizer(target: self, action: #selector(tapBreakDown))
        imgBreakDown.isUserInteractionEnabled = true
        imgBreakDown.addGestureRecognizer(tapBreakDown)
    }
    
    func setData(title: String, description: String, isLast: Bool) {
        self.isLast = isLast
        lblTitle.text = title
        lblDescription.text = description
    }
    
    @objc
    private func tapBreakDown() {
        lblDescription.isHidden = !lblDescription.isHidden
        imgBreakDown.image = lblDescription.isHidden ? #imageLiteral(resourceName: "arrow_down_blue.svg") : #imageLiteral(resourceName: "arrow_up_blue.svg")
        if let action = handleBreakDown {
            action()
        }
    }
}
