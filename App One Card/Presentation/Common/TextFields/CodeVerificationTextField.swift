//
//  CodeVerificationTextField.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import UIKit

//class BackwardTextField: UITextField {
//    var backspaceCalled: (() -> Void)?
//
//    override func deleteBackward() {
//        super.deleteBackward()
//        backspaceCalled?()
//    }
//}

//class CodeVerificationTextField: UIView {
//
//    private lazy var viewContainer: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private lazy var stackViewTextFields: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: codeTextFields)
//        stackView.axis = .horizontal
//        stackView.spacing = 4
//        stackView.alignment = .center
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//
//    let codeLength = 4
//    var codeTextFields = [UITextField]()
//    var current = 0
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupView()
//    }
//
//    func setupView() {
//        for _ in 0..<codeLength {
//            let textField = BackwardTextField()
//            textField.delegate = self
//            textField.textAlignment = .center
//            textField.keyboardType = .numberPad
//            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//            textField.layer.borderWidth = 1
//            textField.backgroundColor = .white
//            textField.layer.borderColor = Design.color(.grey40).cgColor
//            textField.translatesAutoresizingMaskIntoConstraints = false
//            textField.widthAnchor.constraint(equalToConstant: 56).isActive = true
//            textField.heightAnchor.constraint(equalToConstant: 56).isActive = true
//            textField.backspaceCalled = {
//                if self.current > 0 {
//                    self.codeTextFields[self.current].text = ""
//                    self.codeTextFields[self.current - 1].becomeFirstResponder()
//                } else {
//                    print(self.current)
//                }
//            }
//            codeTextFields.append(textField)
//        }
//
//        addSubview(viewContainer)
//        viewContainer.addSubview(stackViewTextFields)
//
//        NSLayoutConstraint.activate([
//            viewContainer.topAnchor.constraint(equalTo: self.topAnchor),
//            viewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            viewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            viewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//
//            stackViewTextFields.topAnchor.constraint(equalTo: viewContainer.topAnchor),
//            stackViewTextFields.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
//            stackViewTextFields.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
//            stackViewTextFields.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor),
//        ])
//
//        // Focus the first text field for code input
//        //codeTextFields.first?.becomeFirstResponder()
//    }
//
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        guard let currentIndex = codeTextFields.firstIndex(of: textField) else { return }
//        current = currentIndex
//
//        // Move to the next text field once the current one is filled
//        if textField.text?.count == 1 {
//            if current < codeTextFields.count - 1 {
//                codeTextFields[current + 1].becomeFirstResponder()
//            } else {
//                textField.resignFirstResponder()
//
//            }
//        } else {
//            print("es vacio")
//        }
//    }
//}
//
//extension CodeVerificationTextField: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
////        guard let currentIndex = codeTextFields.firstIndex(where: { textField in (textField.text ?? "").isEmpty }) else {
////            currentIndexTextField = (codeTextFields.count - 1)
////            codeTextFields[currentIndexTextField].becomeFirstResponder()
////            return
////        }
////
////        //currentIndexTextField = currentIndex
////        if currentIndexTextField > 0 {
////            //codeTextFields[currentIndexTextField].becomeFirstResponder()
////            if currentIndexTextField > (currentIndexTextField + 1) {
////                codeTextFields[currentIndexTextField + 1].becomeFirstResponder()
////            }
////        }  else {
////            codeTextFields[currentIndexTextField].becomeFirstResponder()
////        }
//        guard let currentIndex = codeTextFields.firstIndex(of: textField) else {
//            return
//        }
//        current = currentIndex
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // Allow only numeric input and limit the length to 4 characters
//
//        guard let currentIndex = codeTextFields.firstIndex(of: textField) else { return true }
//        current = currentIndex
//
//        // Move back to the previous text field if backspace is pressed
//        if string.isEmpty && range.length == 1 && current > 0 {
//            textField.text = ""
//            codeTextFields[current - 1].becomeFirstResponder()
//            return false
//        }
//
//        let allowedCharacters = CharacterSet.decimalDigits
//        let characterSet = CharacterSet(charactersIn: string)
//        return allowedCharacters.isSuperset(of: characterSet) && (textField.text ?? "").count == 0
//    }
//}

class CodeVerificationTextField: UITextField {
    
    var didEnterLastDigit: ((String) -> Void)?
    
    private var isConfigured = false
    
    private var digitLabels = [UILabel]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    func configure(with slotCount: Int = 4) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureTextField()
        
        let viewsStackView = createViewsStackView(with: slotCount)
        addSubview(viewsStackView)
        
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            viewsStackView.topAnchor.constraint(equalTo: topAnchor),
            viewsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.distribution = .fill
        
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
            
            NSLayoutConstraint.activate([
                label.heightAnchor.constraint(equalToConstant: 56),
                label.widthAnchor.constraint(equalToConstant: 56),
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
                currentLabel.text = String(text[index])
            } else {
                currentLabel.text?.removeAll()
            }
        }
        
        if text.count == digitLabels.count {
            didEnterLastDigit?(text)
            self.resignFirstResponder()
        }
    }
}

extension CodeVerificationTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitLabels.count || string == ""
    }
}
