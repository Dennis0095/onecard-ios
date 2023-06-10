//
//  OutlinedTextField.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

class OutlinedTextField: UIView {
    
    private let viewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewError: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewPlaceholder: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var txt: PaddedTextField = {
        let textfield = PaddedTextField()
        textfield.paddingLeft = 15
        //textfield.paddingRight = 15
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let lblPlaceholder: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = ""
        label.textColor = Design.color(.grey60)
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblError: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = ""
        label.textColor = .red//Design.color(.primary60)
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackInput: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 4
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var imgPassword: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "password_hide")
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    internal var keyBoardType: UIKeyboardType = .default
    internal var hasError: Bool = false
    internal var isPlaceholderOnTop: Bool = false
    internal var errorMessage: String?
    internal var isValid: Bool = false {
        didSet {
            if errorMessage != nil {
                hasError = !isValid
            }
            changeStatus(status: isValid ? .focused : .error)
        }
    }
    
    internal var status: OutlinedTextFieldStatus = .activated {
        didSet {
            changeStatus(status: status)
        }
    }
    internal var listenChanges: ((_ text: String) -> Void)?
    internal var selectTextField: ((_ textField: UITextField?) -> Void)?
    
    var isSecureTextField: Bool = false {
        didSet {
            imgPassword.image = isSecureTextField ? UIImage(named: "password_show") : UIImage(named: "password_hide")
            txt.isSecureTextEntry = !isSecureTextField
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupView()
        addActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setupView()
        addActions()
    }
    
    func addActions() {
        let tapViewPlaceholder = UITapGestureRecognizer(target: self, action: #selector(tapViewPlaceholder))
        viewPlaceholder.isUserInteractionEnabled = true
        viewPlaceholder.addGestureRecognizer(tapViewPlaceholder)
        
        let tapPassword = UITapGestureRecognizer(target: self, action: #selector(imgPasswordTapped))
        imgPassword.isUserInteractionEnabled = true
        imgPassword.addGestureRecognizer(tapPassword)
    }
    
    func setupView(isPassword: Bool) {
        txt.layer.borderWidth = 1
        txt.delegate = self
        txt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.addSubview(stackInput)
        self.stackInput.addArrangedSubview(viewContainer)
        self.stackInput.addArrangedSubview(viewError)
        self.viewContainer.addSubview(txt)
        self.viewContainer.addSubview(viewPlaceholder)
        self.viewContainer.addSubview(imgPassword)
        self.viewPlaceholder.addSubview(lblPlaceholder)
        self.viewError.addSubview(lblError)
        
        imgPassword.isHidden = !isPassword
        
        NSLayoutConstraint.activate([
            stackInput.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackInput.topAnchor.constraint(equalTo: self.topAnchor),
            stackInput.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackInput.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackInput.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                        
            imgPassword.heightAnchor.constraint(equalToConstant: 24),
            imgPassword.widthAnchor.constraint(equalToConstant: 24),
            imgPassword.trailingAnchor.constraint(equalTo: self.viewContainer.trailingAnchor, constant: -15),
            imgPassword.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor),
            
            txt.heightAnchor.constraint(equalToConstant: 56),
            txt.topAnchor.constraint(equalTo: self.viewContainer.topAnchor),
            txt.leadingAnchor.constraint(equalTo: self.viewContainer.leadingAnchor),
            txt.trailingAnchor.constraint(equalTo: self.viewContainer.trailingAnchor),
            txt.bottomAnchor.constraint(equalTo: self.viewContainer.bottomAnchor),
            
            viewPlaceholder.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor),
            viewPlaceholder.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 12),
            viewPlaceholder.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -(12 + (isPassword ? 34 : 0))),
            
            lblPlaceholder.topAnchor.constraint(equalTo: self.viewPlaceholder.topAnchor),
            lblPlaceholder.leadingAnchor.constraint(equalTo: self.viewPlaceholder.leadingAnchor, constant: 4),
            lblPlaceholder.trailingAnchor.constraint(equalTo: self.viewPlaceholder.trailingAnchor, constant: -4),
            lblPlaceholder.bottomAnchor.constraint(equalTo: self.viewPlaceholder.bottomAnchor),
            
            lblError.topAnchor.constraint(equalTo: self.viewError.topAnchor),
            lblError.leadingAnchor.constraint(greaterThanOrEqualTo: self.viewError.leadingAnchor),
            lblError.trailingAnchor.constraint(equalTo: self.viewError.trailingAnchor),
            lblError.bottomAnchor.constraint(equalTo: self.viewError.bottomAnchor),
        ])
        
        txt.paddingRight = isPassword ? (34 + 15) : 15
        
        viewError.isHidden = true
    }
    
    func configure(placeholder: String? = "", errorMessage: String? = nil, status: OutlinedTextFieldStatus, type: UIKeyboardType? = nil, isPassword: Bool? = false) {
        lblPlaceholder.text = placeholder
        lblError.text = errorMessage
        
        if let type = type {
            self.keyBoardType = type
            txt.keyboardType = type
        }
        
        self.errorMessage = errorMessage
        self.status = status
        
        txt.setFont(UIFont.systemFont(ofSize: 14), Design.color(.grey100))
        txt.isSecureTextEntry = isPassword!
        
        setupView(isPassword: isPassword!)
    }
    
    func setHeader(header: String) {
        lblPlaceholder.text = header
    }
    
    func changeStatus(status: OutlinedTextFieldStatus) {
        switch status {
        case .activated:
            alpha = 1.0
            lblPlaceholder.textColor = Design.color(.grey60)
            txt.layer.borderColor = Design.color(.grey20).cgColor
            txt.backgroundColor = .white
            txt.textColor = Design.color(.grey100)
            viewPlaceholder.backgroundColor = .white
            txt.isEnabled = true
            
            if errorMessage != nil {
                viewError.isHidden = true
            }
        case .focused:
            alpha = 1.0
            txt.layer.borderColor = Design.color(.primary).cgColor
            lblPlaceholder.textColor = Design.color(.grey100)
            txt.backgroundColor = .white
            txt.textColor = Design.color(.grey100)
            viewPlaceholder.backgroundColor = .white
            txt.isEnabled = true
            
            if errorMessage != nil {
                viewError.isHidden = true
            }
        case .disabled:
            alpha = 0.6
            lblPlaceholder.textColor = Design.color(.grey60)
            txt.layer.borderColor = Design.color(.grey20).cgColor
            txt.backgroundColor = .white
            txt.textColor = Design.color(.grey100)
            viewPlaceholder.backgroundColor = .white
            txt.isEnabled = false
            
            if errorMessage != nil {
                viewError.isHidden = true
            }
        case .error:
            alpha = 1.0
            txt.backgroundColor = .white
            txt.textColor = Design.color(.grey100)
            viewPlaceholder.backgroundColor = .white
            txt.isEnabled = true
            
            if errorMessage != nil {
                lblPlaceholder.textColor = isPlaceholderOnTop ? .red : Design.color(.grey60)
                txt.layer.borderColor = UIColor.red.cgColor
                viewError.isHidden = false
            }
        }
    }
    
    func showPlaceholderOnTop() {
        isPlaceholderOnTop = true
        viewPlaceholder.removeAllConstraints()
        
        lblPlaceholder.font = UIFont.systemFont(ofSize: 12)
        
        NSLayoutConstraint.activate([
            viewPlaceholder.topAnchor.constraint(equalTo: self.viewContainer.topAnchor, constant: -8),
            viewPlaceholder.leadingAnchor.constraint(equalTo: self.viewContainer.leadingAnchor, constant: 10),
            viewPlaceholder.trailingAnchor.constraint(lessThanOrEqualTo: self.viewContainer.trailingAnchor, constant: -10),
            
            lblPlaceholder.topAnchor.constraint(equalTo: self.viewPlaceholder.topAnchor),
            lblPlaceholder.leadingAnchor.constraint(equalTo: self.viewPlaceholder.leadingAnchor, constant: 4),
            lblPlaceholder.trailingAnchor.constraint(equalTo: self.viewPlaceholder.trailingAnchor, constant: -4),
            lblPlaceholder.bottomAnchor.constraint(equalTo: self.viewPlaceholder.bottomAnchor),
        ])
        
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
    
    func showPlaceholderOnCenter() {
        isPlaceholderOnTop = false
        viewPlaceholder.removeAllConstraints()
        
        lblPlaceholder.font = UIFont.systemFont(ofSize: 14)
        
        NSLayoutConstraint.activate([
            viewPlaceholder.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor),
            viewPlaceholder.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 12),
            viewPlaceholder.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -(12 + (imgPassword.isHidden ? 0 : 34))),
            
            lblPlaceholder.topAnchor.constraint(equalTo: self.viewPlaceholder.topAnchor),
            lblPlaceholder.leadingAnchor.constraint(equalTo: self.viewPlaceholder.leadingAnchor, constant: 4),
            lblPlaceholder.trailingAnchor.constraint(equalTo: self.viewPlaceholder.trailingAnchor, constant: -4),
            lblPlaceholder.bottomAnchor.constraint(equalTo: self.viewPlaceholder.bottomAnchor),
        ])
        
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
    
    @objc private func tapViewPlaceholder() {
        if !isPlaceholderOnTop {
            isPlaceholderOnTop = true
            
            txt.becomeFirstResponder()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let changes = listenChanges {
            let trimText = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            self.isValid = !trimText.isEmpty
            changes(trimText)
        }
    }
    
    @objc private func imgPasswordTapped() {
        isSecureTextField.toggle()
    }
}

extension OutlinedTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let changes = selectTextField {
            changes(nil)
        }
        
        if hasError {
            status = .error
        } else {
            status = .activated
        }
        
        if (textField.text ?? "").isEmpty {
            showPlaceholderOnCenter()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let changes = selectTextField {
            changes(textField)
        }
        
        if hasError {
            status = .error
        } else {
            status = .focused
        }
        
        if (textField.text ?? "").isEmpty {
            showPlaceholderOnTop()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch keyBoardType {
        case .numberPad:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            
            return allowedCharacters.isSuperset(of: characterSet)
        case .decimalPad:
            guard let currentText = textField.text else {
                return true
            }
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return updatedText.validateString(withRegex: .decimal)
        default:
            return true
        }
    }
}

enum OutlinedTextFieldStatus {
    case activated
    case focused
    case disabled
    case error
}
