//
//  PersonalDataViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

class PersonalDataViewController: BaseViewController {

    @IBOutlet weak var txtName: OutlinedTextField!
    @IBOutlet weak var txtLastName: OutlinedTextField!
    @IBOutlet weak var txtBirthday: SelectTextField!
    @IBOutlet weak var txtPhone: OutlinedTextField!
    @IBOutlet weak var txtEmail: OutlinedTextField!
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedDate: Date?
    
    private var viewModel: PersonalDataViewModelProtocol
    
    init(viewModel: PersonalDataViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        txtName.configure(placeholder: Constants.placeholder_name, errorMessage: Constants.error, status: .activated)
        txtLastName.configure(placeholder: Constants.placeholder_last_name, errorMessage: Constants.error, status: .activated)
        txtBirthday.configure(placeholder: Constants.placeholder_birthday, status: .activated, imageSelect: #imageLiteral(resourceName: "calendar"))
        txtPhone.configure(placeholder: Constants.placeholder_phone, errorMessage: Constants.error, status: .activated, type: .numberPad)
        txtEmail.configure(placeholder: Constants.placeholder_email, errorMessage: Constants.error, status: .activated, type: .emailAddress)
        btnNext.configure(text: Constants.next_btn, status: .enabled)
        
        connectFields(textFields: txtName.txt, txtLastName.txt, txtPhone.txt, txtEmail.txt)
    }

    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        [txtName, txtLastName, txtPhone, txtEmail].forEach {
            $0.selectTextField = { textField in
                self.selectedTextField = textField
            }
        }
        
        txtBirthday.action = {
            self.viewModel.showDateList(selected: self.selectedDate, action: { date in
                if let date = date {
                    self.selectedDate = date
                    let strDate = DateUtils.shared.getFormattedDate(date: date, outputFormat: "dd/MM/yyyy")
                    self.txtBirthday.setText(string: strDate)
                    self.viewModel.birthday = strDate
                }
                self.txtBirthday.status = .activated
            }, presented: {
                self.txtBirthday.status = .focused
            })
        }
        
        txtName.listenChanges = { [weak self] text in
            self?.viewModel.name = text
        }
        
        txtLastName.listenChanges = { [weak self] text in
            self?.viewModel.lastName = text
        }
        
        txtPhone.listenChanges = { [weak self] text in
            self?.viewModel.cellphone = text
        }
        
        txtEmail.listenChanges = { [weak self] text in
            self?.viewModel.email = text
        }
    }
    
    override func manageScroll() {
        self.baseScrollView = scrollView
    }
    
    private func validate() -> Bool {
        txtName.errorMessage = txtName.text.isEmpty ? "Ingresa tus nombres" : "Debe contener solo letras"
        txtLastName.errorMessage = txtLastName.text.isEmpty ? "Ingresa tus apellidos" : "Debe contener solo letras"
        txtBirthday.errorMessage = "Ingresa tu fecha de nacimiento"
        txtPhone.errorMessage = txtPhone.text.isEmpty ? "Ingresa tu número de celular" : txtPhone.text.validateString(withRegex: .startsWith9) ? "Debe contener 9 números." : "Debe empezar con 9"
        txtEmail.errorMessage = txtEmail.text.isEmpty ? "Ingresa tu correo electrónico" : "Ingresa un correo válido"
        
        txtName.isValid = txtName.text.validateString(withRegex: .name)
        txtLastName.isValid = txtLastName.text.validateString(withRegex: .name)
        txtBirthday.isValid = !txtBirthday.text.isEmpty
        txtPhone.isValid = txtPhone.text.validateString(withRegex: .contain9numbers) && txtPhone.text.validateString(withRegex: .startsWith9)
        txtEmail.isValid = txtEmail.text.validateString(withRegex: .email)
        
        return txtName.isValid && txtLastName.isValid && txtBirthday.isValid && txtPhone.isValid && txtEmail.isValid
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        if validate() {
            viewModel.validateFields()
        }
    }
}

extension PersonalDataViewController: PersonalDataViewModelDelegate {}
