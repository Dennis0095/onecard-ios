//
//  MenuTabBarItem.swift
//  App One Card
//
//  Created by Paolo Arambulo on 10/06/23.
//

import UIKit

class MenuTabBarItem: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var viewSelected: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgItem: UIImageView!
    
    var titleMenu: String?
    var imgMenu: UIImage?
    var action: VoidActionHandler?
    
    var isSelectedItem: Bool = false {
        didSet {
            lblTitle.font = !isSelectedItem ? UIFont(name: "ProximaNova-Medium", size: 12) : UIFont(name: "ProximaNova-Bold", size: 12)
            viewSelected.isHidden = !isSelectedItem
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        addActions()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        addActions()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MenuTabBarItem", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func configure(title: String, image: UIImage) {
        lblTitle.text = title
        imgItem.image = image
    }
    
    func addActions() {
        let select = UITapGestureRecognizer(target: self, action: #selector(selectItem))
        viewMenu.isUserInteractionEnabled = true
        viewMenu.addGestureRecognizer(select)
    }
    
    @objc
    func selectItem() {
        if let action = action {
            action()
        }
    }

}
