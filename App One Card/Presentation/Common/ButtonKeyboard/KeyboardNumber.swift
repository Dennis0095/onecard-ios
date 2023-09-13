//
//  KeyboardNumber.swift
//  App One Card
//
//  Created by Paolo Arambulo on 22/06/23.
//

typealias ButtonActionHandler = ((String) -> Void)

import UIKit

class KeyboardNumber: UIView {
    
    var actionButton: ButtonActionHandler?
    var actionClear: VoidActionHandler?
    
    private let stackView = UIStackView()
    private var listTitle = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
//        Bundle.main.loadNibNamed("KeyboardNumber", owner: self)
//        addSubview(contentView)
//        contentView.frame = self.bounds
//        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
        // Configure the stack view
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
        
        generateRandomButtons()
    }
    
    func generateRandomButtons() {
        let numberOfColumns = 3
        let numberOfRows = 4
        let buttonWidth: CGFloat = 64
        let buttonHeight: CGFloat = 64
        
        for numberRow in 0..<numberOfRows {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10.0
            rowStackView.alignment = .fill
            rowStackView.distribution = .equalSpacing
            
            for numberColumn in 0..<numberOfColumns {
                let randomButton = UIButton()
                randomButton.layer.cornerRadius = 32
                
                if numberRow == 3 && (numberColumn == 0 || numberColumn == 2) {
                    if numberColumn == 2 {
                        randomButton.tag = 11
                        randomButton.backgroundColor = .clear
                        randomButton.setImage(#imageLiteral(resourceName: "keyboard_delete"), for: .normal)
                        
                        randomButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
                        randomButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
                    } else {
                        randomButton.tag = 10
                        randomButton.backgroundColor = .clear
                        
                        randomButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
                        randomButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
                    }
                } else {
                    randomButton.setTitle(getNumberAndRemove(), for: .normal)
                    randomButton.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
                    randomButton.setTitleColor(#colorLiteral(red: 0.2784313725, green: 0.2941176471, blue: 0.3019607843, alpha: 1), for: .normal)
                    randomButton.titleLabel?.font = UIFont(name: "ProximaNova-Medium", size: 20)
                    
                    randomButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
                    randomButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
                }
                
                randomButton.addTarget(self, action: #selector(randomButtonTapped(_:)), for: .touchUpInside)
                
                rowStackView.addArrangedSubview(randomButton)
            }
            
            stackView.addArrangedSubview(rowStackView)
        }
    }
    
    func getNumberAndRemove() -> String {
        if let randomInt = listTitle.randomElement() {
            
            if let index = listTitle.firstIndex(of: randomInt) {
                listTitle.remove(at: index)
            }
            
            return String(randomInt)
        } else {
            return ""
        }
    }
    
    @objc func randomButtonTapped(_ sender: UIButton) {
        if sender.tag == 11 {
            if let action = actionClear {
                action()
            }
        } else {
            if let buttonText = sender.titleLabel?.text {
                if let action = actionButton {
                    action(buttonText)
                }
            }
        }
    }
}
