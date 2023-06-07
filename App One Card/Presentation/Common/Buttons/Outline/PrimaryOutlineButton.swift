//
//  PrimaryOutlineButton.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

class PrimaryOutlineButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func configure(text: String) {
        setTitle(text, for: .normal)
    }
    
    func setupView() {
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = Design.color(.primary).cgColor
        backgroundColor = .white
        setTitleColor(Design.color(.primary), for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
}
