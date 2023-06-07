//
//  PersonalDataViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

class PersonalDataViewController: UIViewController {

    @IBOutlet weak var txtName: OutlinedTextField!
    @IBOutlet weak var txtLastName: OutlinedTextField!
    @IBOutlet weak var txtBirthday: SelectTextField!
    @IBOutlet weak var txtPhone: OutlinedTextField!
    @IBOutlet weak var txtEmail: OutlinedTextField!
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    @IBOutlet weak var imgBack: UIImageView!
    
    var selectedDate: Date?
    
    private var viewModel: PersonalDataViewModelProtocol
    
    init(viewModel: PersonalDataViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtName.configure(placeholder: Constants.placeholder_name, errorMessage: Constants.error, status: .activated)
        txtLastName.configure(placeholder: Constants.placeholder_last_name, errorMessage: Constants.error, status: .activated)
        txtBirthday.configure(placeholder: Constants.placeholder_birthday, errorMessage: Constants.error, status: .activated, imageSelect: #imageLiteral(resourceName: "calendar"))
        txtPhone.configure(placeholder: Constants.placeholder_phone, errorMessage: Constants.error, status: .activated, type: .numberPad)
        txtEmail.configure(placeholder: Constants.placeholder_email, errorMessage: Constants.error, status: .activated, type: .emailAddress)
        btnNext.configure(text: Constants.next_btn, status: .enabled)
        
        addActions()
    }
    
    func addActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        txtBirthday.action = { [weak self] in
            self?.viewModel.showDateList(selected: self?.selectedDate, action: { date in
                if let date = date {
                    self?.selectedDate = date
                    let strDate = DateUtils.shared.getFormattedDate(date: date, outputFormat: "dd/MM/yyyy")
                    self?.txtBirthday.setText(string: strDate)
                }
                self?.txtBirthday.status = .activated
            }, presented: {
                self?.txtBirthday.status = .focused
            })
        }
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        viewModel.nextStep()
    }
    
}
