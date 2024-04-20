//
//  MembershipDataViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

class MembershipDataViewController: BaseViewController {
    
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var viewDocType: SelectTextField!
    @IBOutlet weak var viewDocNumber: OutlinedTextField!
    @IBOutlet weak var viewRuc: OutlinedTextField!
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var viewModel: MembershipDataViewModelProtocol
    
    private var navTitle: String
    private var step: String
    
    init(viewModel: MembershipDataViewModelProtocol, navTitle: String, step: String) {
        self.viewModel = viewModel
        self.navTitle = navTitle
        self.step = step
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initView() {
        lblNavTitle.text = navTitle
        lblStep.text = step
        
        viewModel.documentType = viewModel.documentTypeList.first
        
        viewDocType.configure(placeholder: Constants.placeholder_document_type, errorMessage: Constants.error, status: .activated, imageSelect: #imageLiteral(resourceName: "arrow_down_blue"))
        viewDocNumber.configure(placeholder: Constants.placeholder_document_number, errorMessage: "Ingresa tu número de documento", status: .activated, type: .numberPad)
        viewRuc.configure(placeholder: Constants.placeholder_ruc, errorMessage: "Ingresa el RUC", status: .activated)
        btnNext.configure(text: Constants.next_btn, status: .enabled)
        
        viewDocType.setText(string: viewModel.documentType?.name ?? "DNI")
        viewDocType.status = .defaultData
        viewDocNumber.setPlaceholder(placeholder: viewModel.documentType?.name ?? "DNI")

        connectFields(textFields: viewDocNumber.txt, viewRuc.txt)
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        viewDocType.action = { [weak self] in
            self?.viewModel.showDocumentList(selected: self?.viewModel.documentType, list: self?.viewModel.documentTypeList ?? [], action: { item in
                if let item = item {
                    self?.viewModel.documentType = item
                    self?.viewDocType.setText(string: item.name)
                    self?.viewDocNumber.setPlaceholder(placeholder: item.name)
                    switch item.id {
                    case "3":
                        self?.viewDocNumber.txt.keyboardType = .namePhonePad
                    default:
                        self?.viewDocNumber.txt.keyboardType = .numberPad
                    }
                }
                self?.viewDocType.status = .activated
            }, presented: {
                self?.viewDocType.status = .focused
            })
        }
        
        [viewDocNumber, viewRuc].forEach {
            $0.selectTextField = { textField in
                self.selectedTextField = textField
            }
        }
        
        viewDocNumber.listenChanges = { [weak self] text in
            self?.viewModel.documentNumber = text
        }
        
        viewRuc.listenChanges = { [weak self] text in
            self?.viewModel.companyRUC = text
        }
    }
    
    override func manageScroll() {
        self.baseScrollView = scrollView
    }
    
    private func validate() -> Bool {
        switch viewModel.documentType?.id {
        case "1":
            viewDocNumber.errorMessage = viewDocNumber.text.isEmpty ? "Ingresa tu número de documento." : "Debe contener 8 números."
            viewDocNumber.isValid = viewDocNumber.text.validateString(withRegex: .contain8numbers)
        case "2":
            viewDocNumber.errorMessage = viewDocNumber.text.isEmpty ? "Ingresa tu carnet de extranjería." : "Debe contener entre 9 a 12 números."
            viewDocNumber.isValid = viewDocNumber.text.validateString(withRegex: .contain9to12numbers)
        case "3":
            viewDocNumber.errorMessage = viewDocNumber.text.isEmpty ? "Ingresa tu pasaporte." : "Debe contener entre 9 a 12 caracteres."
            viewDocNumber.isValid = viewDocNumber.text.validateString(withRegex: .contain9to12characters)
        case "5":
            viewDocNumber.errorMessage = viewDocNumber.text.isEmpty ? "Ingresa tu RUC." : "Debe contener 11 números."
            viewDocNumber.isValid = viewDocNumber.text.validateString(withRegex: .contain11numbers)
        case "7":
            viewDocNumber.errorMessage = viewDocNumber.text.isEmpty ? "Ingresa tu permiso temporal de permanencia." : "Debe contener 9 números.."
            viewDocNumber.isValid = viewDocNumber.text.validateString(withRegex: .contain9numbers)
        default: break
        }
        
        viewRuc.errorMessage = viewRuc.text.isEmpty ? "Ingresa el RUC." : "Debe contener 11 números."
        viewRuc.isValid = viewRuc.text.validateString(withRegex: .contain11numbers)
        
        return viewDocNumber.isValid && viewRuc.isValid
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        if validate() {
            switch viewModel.validateType {
            case .REGISTER:
                viewModel.validateUserToRegister()
            case .RECOVER_PASSWORD:
                viewModel.validateUserToRecoverPassword()
            case .RECOVER_USER:
                viewModel.validateUserToRecoverUser()
            }
        }
    }
    
}

extension MembershipDataViewController: MembershipDataViewModelDelegate {
    
}
