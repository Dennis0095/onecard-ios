//
//  SelectTextField.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import UIKit

class SelectTextField: UIView {
    
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
        
    private lazy var lblSelected: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = ""
        label.textColor = Design.color(.grey100)
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var viewSelected: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.addSubview(lblSelected)
        view.addSubview(imgSelect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        label.textColor = .red
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
    
    private lazy var imgSelect: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    internal var hasError: Bool = false
    internal var isPlaceholderOnTop: Bool = false
    internal var errorMessage: String?
    
    internal var text: String = "" {
        didSet {
            lblSelected.text = text
        }
    }
    
//    internal var isValid: Bool = false {
//        didSet {
//            if errorMessage != nil {
//                hasError = !isValid
//            }
//            changeStatus(status: isValid ? .focused : .error)
//        }
//    }

    internal var status: OutlinedTextFieldStatus = .activated {
        didSet {
            changeStatus(status: status)
        }
    }
    
    var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        addActions()
    }
    
    func setupView() {
        self.addSubview(stackInput)
        self.stackInput.addArrangedSubview(viewContainer)
        self.stackInput.addArrangedSubview(viewError)
        self.viewContainer.addSubview(viewSelected)
        self.viewContainer.addSubview(viewPlaceholder)
        self.viewPlaceholder.addSubview(lblPlaceholder)
        self.viewError.addSubview(lblError)
        
        NSLayoutConstraint.activate([
            stackInput.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackInput.topAnchor.constraint(equalTo: self.topAnchor),
            stackInput.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackInput.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackInput.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            viewSelected.heightAnchor.constraint(equalToConstant: 56),
            viewSelected.topAnchor.constraint(equalTo: self.viewContainer.topAnchor),
            viewSelected.leadingAnchor.constraint(equalTo: self.viewContainer.leadingAnchor),
            viewSelected.trailingAnchor.constraint(equalTo: self.viewContainer.trailingAnchor),
            viewSelected.bottomAnchor.constraint(equalTo: self.viewContainer.bottomAnchor),
            
            lblSelected.centerYAnchor.constraint(equalTo: viewSelected.centerYAnchor),
            lblSelected.leadingAnchor.constraint(equalTo: self.viewSelected.leadingAnchor, constant: 15),
            
            imgSelect.leadingAnchor.constraint(equalTo: self.lblSelected.trailingAnchor, constant: 10),
            imgSelect.trailingAnchor.constraint(equalTo: self.viewSelected.trailingAnchor, constant: -15),
            imgSelect.heightAnchor.constraint(equalToConstant: 24),
            imgSelect.widthAnchor.constraint(equalToConstant: 24),
            imgSelect.centerYAnchor.constraint(equalTo: lblSelected.centerYAnchor),
            
            viewPlaceholder.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor),
            viewPlaceholder.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 12),
            viewPlaceholder.trailingAnchor.constraint(equalTo: imgSelect.leadingAnchor, constant: -10),
            
            lblPlaceholder.topAnchor.constraint(equalTo: self.viewPlaceholder.topAnchor),
            lblPlaceholder.leadingAnchor.constraint(equalTo: self.viewPlaceholder.leadingAnchor, constant: 4),
            lblPlaceholder.trailingAnchor.constraint(equalTo: self.viewPlaceholder.trailingAnchor, constant: -4),
            lblPlaceholder.bottomAnchor.constraint(equalTo: self.viewPlaceholder.bottomAnchor),
            
            lblError.topAnchor.constraint(equalTo: self.viewError.topAnchor),
            lblError.leadingAnchor.constraint(greaterThanOrEqualTo: self.viewError.leadingAnchor),
            lblError.trailingAnchor.constraint(equalTo: self.viewError.trailingAnchor),
            lblError.bottomAnchor.constraint(equalTo: self.viewError.bottomAnchor),
        ])
        
        viewError.isHidden = true
    }
    
    func addActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapSelect))
        imgSelect.isUserInteractionEnabled = true
        imgSelect.addGestureRecognizer(tap)
    }
    
    func configure(placeholder: String? = "", errorMessage: String? = nil, status: OutlinedTextFieldStatus, imageSelect: UIImage) {
        lblPlaceholder.text = placeholder
        lblError.text = errorMessage
        
        self.errorMessage = errorMessage
        self.status = status
        self.imgSelect.image = imageSelect
    }
    
    func setText(string: String) {
        self.text = string
        self.status = .activated
    }
    
    func changeStatus(status: OutlinedTextFieldStatus) {
        switch status {
        case .activated:
            alpha = 1.0
            lblPlaceholder.textColor = Design.color(.grey60)
            viewSelected.layer.borderColor = Design.color(.grey20).cgColor
            
            if errorMessage != nil {
                viewError.isHidden = true
            }
            
            if text.isEmpty {
                showPlaceholderOnCenter()
            }
        case .focused:
            alpha = 1.0
            viewSelected.layer.borderColor = Design.color(.primary).cgColor
            lblPlaceholder.textColor = Design.color(.grey100)
            
            if errorMessage != nil {
                viewError.isHidden = true
            }
            
            if text.isEmpty {
                showPlaceholderOnTop()
            }
        case .disabled:
            alpha = 0.6
            lblPlaceholder.textColor = Design.color(.grey60)
            viewSelected.layer.borderColor = Design.color(.grey20).cgColor
            
            if errorMessage != nil {
                viewError.isHidden = true
            }
            
            if text.isEmpty {
                showPlaceholderOnCenter()
            }
        case .error:
            alpha = 1.0
            viewPlaceholder.backgroundColor = .white
            
            if errorMessage != nil {
                lblPlaceholder.textColor = isPlaceholderOnTop ? .red : Design.color(.grey60)
                viewSelected.layer.borderColor = UIColor.red.cgColor
                viewError.isHidden = false
            }
            
            if text.isEmpty {
                showPlaceholderOnCenter()
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
            viewPlaceholder.trailingAnchor.constraint(equalTo: imgSelect.leadingAnchor, constant: -10),
            
            lblPlaceholder.topAnchor.constraint(equalTo: self.viewPlaceholder.topAnchor),
            lblPlaceholder.leadingAnchor.constraint(equalTo: self.viewPlaceholder.leadingAnchor, constant: 4),
            lblPlaceholder.trailingAnchor.constraint(equalTo: self.viewPlaceholder.trailingAnchor, constant: -4),
            lblPlaceholder.bottomAnchor.constraint(equalTo: self.viewPlaceholder.bottomAnchor),
        ])
        
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
    
    @objc func tapSelect() {
        if let select = self.action {
            select()
        }
    }
}

enum SelectTextFieldStatus {
    case activated
    case focused
    case disabled
    case error
}
