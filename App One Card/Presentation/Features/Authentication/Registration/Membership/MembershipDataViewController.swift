//
//  MembershipDataViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

class MembershipDataViewController: BaseViewController {
    
    @IBOutlet weak var viewDocType: SelectTextField!
    @IBOutlet weak var viewDocNumber: OutlinedTextField!
    @IBOutlet weak var viewRuc: OutlinedTextField!
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var docTypeList: [SelectModel] = [
        SelectModel(id: 0, name: "DNI"),
        SelectModel(id: 1, name: "Carnet de extranjería")
    ]
    
    private var viewModel: MembershipDataViewModelProtocol
    
    init(viewModel: MembershipDataViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initView() {
        viewModel.docType = docTypeList.first
        
        viewDocType.configure(placeholder: Constants.placeholder_document_type, errorMessage: Constants.error, status: .activated, imageSelect: #imageLiteral(resourceName: "arrow_down"))
        viewDocNumber.configure(placeholder: Constants.placeholder_document_number, errorMessage: "Ingrese su número de documento", status: .activated, type: .numberPad)
        viewRuc.configure(placeholder: Constants.placeholder_ruc, errorMessage: "Ingrese el RUC", status: .activated)
        btnNext.configure(text: Constants.next_btn, status: .enabled)
        
        viewDocType.setText(string: viewModel.docType?.name ?? "DNI")
        viewDocType.status = .defaultData

        connectFields(textFields: viewDocNumber.txt, viewRuc.txt)
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        viewDocType.action = { [weak self] in
            self?.viewModel.showDocumentList(selected: self?.viewModel.docType, list: self?.docTypeList ?? [], action: { item in
                if let item = item {
                    self?.viewModel.docType = item
                    self?.viewDocType.setText(string: item.name)
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
        
        [viewDocNumber, viewRuc].forEach {
            $0.listenChanges = { [weak self] text in
                
            }
        }
    }
    
    override func manageScroll() {
        self.baseScrollView = scrollView
    }
    
    private func validate() -> Bool {
        viewDocNumber.errorMessage = viewDocNumber.text.isEmpty ? "Ingrese su número de documento." : "Debe contener 8 números."
        viewRuc.errorMessage = viewRuc.text.isEmpty ? "Ingrese el RUC." : "Debe contener 11 números."
        
        viewDocNumber.isValid = viewDocNumber.text.validateString(withRegex: .contain8numbers)
        viewRuc.isValid = viewRuc.text.validateString(withRegex: .contain11numbers)
        
        return viewDocNumber.isValid && viewRuc.isValid
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        viewModel.formValidation(isValid: validate())
    }
    
}
