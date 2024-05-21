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
    @IBOutlet weak var imgBreakDown: UIImageView!
    @IBOutlet weak var viewSeparator: UIView!
    
    public var handleBreakDown: VoidActionHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addActions()
    }
    
    func addActions() {
        let tapBreakDown = UITapGestureRecognizer(target: self, action: #selector(tapBreakDown))
        imgBreakDown.isUserInteractionEnabled = true
        imgBreakDown.addGestureRecognizer(tapBreakDown)
        
        let tapTitle = UITapGestureRecognizer(target: self, action: #selector(tapTitle))
        lblTitle.isUserInteractionEnabled = true
        lblTitle.addGestureRecognizer(tapTitle)
    }
    
    func setData(title: String, description: String, isExpanded: Bool, isLast: Bool) {
        lblTitle.text = title
        lblDescription.text = description
        lblDescription.isHidden = !isExpanded
        imgBreakDown.image = !isExpanded ? #imageLiteral(resourceName: "arrow_down_blue.svg") : #imageLiteral(resourceName: "arrow_up_blue.svg")
        viewSeparator.isHidden = !isLast
    }
    
    @objc
    private func tapBreakDown() {
        if let action = handleBreakDown {
            action()
        }
    }
    
    @objc
    private func tapTitle() {
        if let action = handleBreakDown {
            action()
        }
    }
}
