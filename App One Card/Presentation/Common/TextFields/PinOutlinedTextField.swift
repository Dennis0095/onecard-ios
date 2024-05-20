//
//  PinOutlinedTextField.swift
//  App One Card
//
//  Created by Paolo Arambulo on 9/07/23.
//

import UIKit

class PinOutlinedTextField: UIView {
    
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
    
    public lazy var txt: PaddedTextField = {
        let textfield = PaddedTextField()
        textfield.showKeyboard = false
        textfield.paddingLeft = 15
        textfield.font = UIFont(name: "ProximaNova-Medium", size: 15)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.layer.cornerRadius = 8
        return textfield
    }()
    
    private let lblPlaceholder: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = ""
        label.textColor = Design.color(.grey60)
        label.font = UIFont(name: "ProximaNova-Medium", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblError: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = ""
        label.textColor = .red
        label.font = UIFont(name: "ProximaNova-Medium", size: 13)
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
    
    internal var errorMessage: String? {
        didSet {
            lblError.text = errorMessage
        }
    }
    
    internal var isValid: Bool = false {
        didSet {
            if errorMessage != nil {
                hasError = !isValid
            }
            changeStatus(status: isValid ? .activated : .errorUnfocused)
        }
    }
    
    internal var status: PinOutlinedTextFieldStatus = .activated {
        didSet {
            changeStatus(status: status)
        }
    }
    
    internal var listenChanges: ((_ text: String) -> Void)?
    
    internal var selectTextField: ((_ textField: UITextField?) -> Void)?
    
    internal var text: String = "" {
        didSet {
            if text.isEmpty {
                showPlaceholderOnCenter()
            } else {
                showPlaceholderOnTop()
            }
            txt.text = text
        }
    }
    
    internal var isSecureTextField: Bool = false {
        didSet {
            imgPassword.image = isSecureTextField ? UIImage(named: "password_show") : UIImage(named: "password_hide")
            txt.isSecureTextEntry = !isSecureTextField
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addActions()
    }
    
    func addActions() {
        let tapPassword = UITapGestureRecognizer(target: self, action: #selector(imgPasswordTapped))
        imgPassword.isUserInteractionEnabled = true
        imgPassword.addGestureRecognizer(tapPassword)
    }
    
    func setupView(isPassword: Bool) {
        txt.layer.borderWidth = 1
        
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
            lblError.leadingAnchor.constraint(equalTo: self.viewError.leadingAnchor),
            lblError.trailingAnchor.constraint(equalTo: self.viewError.trailingAnchor),
            lblError.bottomAnchor.constraint(equalTo: self.viewError.bottomAnchor),
        ])
        
        txt.paddingRight = isPassword ? (34 + 15) : 15
    }
    
    func configure(placeholder: String? = "", errorMessage: String? = nil, status: PinOutlinedTextFieldStatus, type: UIKeyboardType? = nil, isPassword: Bool? = false) {
        lblPlaceholder.text = placeholder
        
        if let type = type {
            self.keyBoardType = type
            txt.keyboardType = type
        }
        
        self.errorMessage = errorMessage
        txt.isSecureTextEntry = isPassword!
        
        setupView(isPassword: isPassword!)
        self.status = status
    }
    
    func setPlaceholder(placeholder: String) {
        lblPlaceholder.text = placeholder
    }
    
    func changeStatus(status: PinOutlinedTextFieldStatus) {
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
                lblError.textColor = #colorLiteral(red: 0.568627451, green: 0.5764705882, blue: 0.5803921569, alpha: 1)
                lblError.isHidden = false
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
                lblError.textColor = #colorLiteral(red: 0.568627451, green: 0.5764705882, blue: 0.5803921569, alpha: 1)
                lblError.isHidden = true
            }
        case .errorUnfocused:
            alpha = 1.0
            txt.backgroundColor = .white
            txt.textColor = Design.color(.grey100)
            txt.layer.borderColor = Design.color(.grey20).cgColor
            viewPlaceholder.backgroundColor = .white
            txt.isEnabled = true
            
            if errorMessage != nil {
                lblError.textColor = .red
                lblError.isHidden = false
            }
        }
    }
    
    func showPlaceholderOnTop() {
        isPlaceholderOnTop = true
        viewPlaceholder.removeAllConstraints()
        
        lblPlaceholder.font = UIFont(name: "ProximaNova-Medium", size: 13)
        
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
        
        lblPlaceholder.font = UIFont(name: "ProximaNova-Medium", size: 15)
        
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
    
    @objc private func imgPasswordTapped() {
        isSecureTextField.toggle()
    }
}

enum PinOutlinedTextFieldStatus {
    case activated
    case disabled
    case errorUnfocused
}

