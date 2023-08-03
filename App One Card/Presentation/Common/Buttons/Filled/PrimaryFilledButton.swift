//
//  PrimaryFilledButton.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

class PrimaryFilledButton: UIButton {

    var status: PrimaryFilledButtonStatus = .disabled {
        didSet {
            changeStatus(status: status)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    func configure(text: String, status: PrimaryFilledButtonStatus) {
        setTitle(text, for: .normal)
        self.status = status
    }
    
    func changeTitle(text: String) {
        setTitle(text, for: .normal)
    }
    
    func setupView() {
        clipsToBounds = true
        layer.cornerRadius = 20
        backgroundColor = #colorLiteral(red: 0, green: 0.6392156863, blue: 0.8784313725, alpha: 1)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name: "Gotham-Medium", size: 12)
    }
    
    func changeStatus(status: PrimaryFilledButtonStatus) {
        switch status {
        case .enabled:
            alpha = 1.0
            isEnabled = true
        case .disabled:
            alpha = 0.6
            isEnabled = false
        }
    }
}

enum PrimaryFilledButtonStatus {
    case enabled
    case disabled
}
