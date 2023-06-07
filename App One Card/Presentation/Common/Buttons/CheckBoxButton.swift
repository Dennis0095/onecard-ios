//
//  CheckBoxButton.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

class CheckboxButton: UIButton {
    let checkedImage = UIImage(named: "checkbox_checked")
    let uncheckedImage = UIImage(named: "checkbox_unchecked")
    
    var isChecked: Bool = false {
        didSet {
            setImage(isChecked ? checkedImage : uncheckedImage, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCheckboxButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCheckboxButton()
    }
    
    private func setupCheckboxButton() {
        setTitle("", for: .normal)
        addTarget(self, action: #selector(checkboxButtonTapped), for: .touchUpInside)
        isChecked = false
    }
    
    @objc private func checkboxButtonTapped() {
        isChecked.toggle()
    }
}
