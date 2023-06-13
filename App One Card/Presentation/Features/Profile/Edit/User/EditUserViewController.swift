//
//  EditUserViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/06/23.
//

import UIKit

class EditUserViewController: UIViewController {
    @IBOutlet weak var txtUser: OutlinedTextField!
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    @IBOutlet weak var imgBack: UIImageView!
    
    private var viewModel: EditUserViewModelProtocol
    
    init(viewModel: EditUserViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addActions()
        txtUser.configure(placeholder: Constants.placeholder_user, status: .activated)
        btnNext.configure(text: Constants.next_btn, status: .enabled)
    }
    
    func addActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        viewModel.successfulEdit()
    }
}
