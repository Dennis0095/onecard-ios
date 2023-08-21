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
        layer.borderColor = #colorLiteral(red: 0, green: 0.6392156863, blue: 0.8784313725, alpha: 1)
        backgroundColor = .white
        setTitleColor(#colorLiteral(red: 0, green: 0.6392156863, blue: 0.8784313725, alpha: 1), for: .normal)
        titleLabel?.font = UIFont(name: "ProximaNova-Bold", size: 15)
    }
}
