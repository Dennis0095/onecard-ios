//
//  ProfileViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/06/23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imgBack: UIImageView!
    
    private var viewModel: ProfileViewModelProtocol
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addActions()
    }
    
    func addActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editMail(_ sender: Any) {
        viewModel.toEditMail()
    }
    
    @IBAction func editUser(_ sender: Any) {
        viewModel.toEditUser()
    }
    
    @IBAction func editPassword(_ sender: Any) {
        
    }
}
