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
    
    private lazy var docTypePickerView: UIPickerView = {
        let view = UIPickerView()
        return view
    }()
    
    var docTypeList: [SelectModel] = [
        SelectModel(id: 0, name: "DNI"),
        SelectModel(id: 1, name: "Carnet de extranjería")
    ]
    
    var selectedDocType: SelectModel?
    
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
        viewDocType.configure(placeholder: Constants.placeholder_document_type, errorMessage: Constants.error, status: .activated, imageSelect: #imageLiteral(resourceName: "arrow_down"))
        viewDocNumber.configure(placeholder: Constants.placeholder_document_number, errorMessage: Constants.error, status: .activated)
        viewRuc.configure(placeholder: Constants.placeholder_ruc, errorMessage: Constants.error, status: .activated)
        btnNext.configure(text: Constants.next_btn, status: .enabled)
        
        connectFields(textFields: viewDocNumber.txt, viewRuc.txt)
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        viewDocType.action = { [weak self] in
            self?.viewModel.showDocumentList(selected: self?.selectedDocType, list: self?.docTypeList ?? [], action: { item in
                if let item = item {
                    self?.selectedDocType = item
                    self?.viewDocType.setText(string: item.name)
                }
                self?.viewDocType.status = .activated
            }, presented: {
                self?.viewDocType.status = .focused
            })
        }
    }
    
    override func manageScroll() {
        self.baseScrollView = scrollView
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        viewModel.nextStep()
    }
    
}
