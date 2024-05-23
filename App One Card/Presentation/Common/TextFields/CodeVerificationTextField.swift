//
//  CodeVerificationTextField.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import UIKit

class CodeVerificationTextField: UITextField {
    
    var isValid = false
    
    //var didEnterLastDigit: ((String) -> Void)?
    
    var didEnterDigits: ((String) -> Void)?
    
    private var isConfigured = false
    
    private var digitLabels = [UILabel]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    private lazy var lblError: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Debe contener 6 números"
        label.textColor = .red
        label.font = UIFont(name: "ProximaNova-Medium", size: 13)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(with slotCount: Int = 6) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureTextField()
        
        let viewsStackView = createViewsStackView(with: slotCount)
        addSubview(viewsStackView)
        addSubview(lblError)
        
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            viewsStackView.topAnchor.constraint(equalTo: topAnchor),
            viewsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            lblError.topAnchor.constraint(equalTo: viewsStackView.bottomAnchor, constant: 4),
            lblError.leadingAnchor.constraint(equalTo: leadingAnchor),
            lblError.trailingAnchor.constraint(equalTo: trailingAnchor),
            lblError.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    
    private func createViewsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        let spacing: CGFloat = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = spacing
        stackView.distribution = .fillEqually
        
        for _ in 1 ... count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 14)
            label.layer.borderColor = Design.color(.grey40).cgColor
            label.layer.borderWidth = 1
            label.isUserInteractionEnabled = true
            
            stackView.addArrangedSubview(label)
            
            digitLabels.append(label)
            
            let totalSpacing: CGFloat = CGFloat((count - 1)) * spacing
            let width = (self.frame.size.width - totalSpacing) / CGFloat(count)
            
            NSLayoutConstraint.activate([
                label.heightAnchor.constraint(equalToConstant: width),
                //label.widthAnchor.constraint(equalToConstant: width),
            ])
            
        }
        
        return stackView
    }
    
    @objc
    private func textDidChange() {
        guard let text = self.text, text.count <= digitLabels.count else { return }
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.layer.borderColor = Design.color(.primary).cgColor
                currentLabel.text = String(text[index])
            } else {
                currentLabel.layer.borderColor = Design.color(.grey40).cgColor
                currentLabel.text?.removeAll()
            }
        }
        
        didEnterDigits?(text)
        
        if text.count == digitLabels.count {
            //didEnterLastDigit?(text)
            self.resignFirstResponder()
            isValid = true
        } else {
            isValid = false
        }
    }
    
    func validateIsValid() -> Bool {
        lblError.text = (self.text ?? "").isEmpty ? "Ingresa el código de validación" : "Debe contener 6 números"
        
        if isValid {
            lblError.isHidden = true
            return true
        } else {
            lblError.isHidden = false
            return false
        }
    }
}

extension CodeVerificationTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }

        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)

        return (characterCount < digitLabels.count || string == "") && allowedCharacters.isSuperset(of: characterSet)
    }
}
