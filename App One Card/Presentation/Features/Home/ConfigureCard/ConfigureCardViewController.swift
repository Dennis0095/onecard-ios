//
//  ConfigureCardViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/06/23.
//

import UIKit

class ConfigureCardViewController: BaseViewController {
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var tbConfigureCard: UITableView!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var viewConfigure: UIView!
    @IBOutlet weak var btnSave: PrimaryFilledButton!
    
    private var viewModel: ConfigureCardViewModelProtocol
    private var configureCardDelegateDataSource: ConfigureCardDelegateDataSource
    
    init(viewModel: ConfigureCardViewModelProtocol, configureCardDelegateDataSource: ConfigureCardDelegateDataSource) {
        self.viewModel = viewModel
        self.configureCardDelegateDataSource = configureCardDelegateDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        viewError.isHidden = true
        viewConfigure.isHidden = true
        
        tbConfigureCard.delegate = configureCardDelegateDataSource
        tbConfigureCard.dataSource = configureCardDelegateDataSource
        
        tbConfigureCard.register(UINib(nibName: "ConfigureCardTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfigureCardTableViewCell")
        
        btnSave.configure(text: "GUARDAR CAMBIOS", status: .disabled)
        
        viewModel.getCardStatusAndOnlineShoppingStatus()
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
    }
    
    @objc
    private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        viewModel.saveChanges()
    }
}

extension ConfigureCardViewController: ConfigureCardViewModelDelegate {
    func changeStatus() {
        DispatchQueue.main.async {
            self.tbConfigureCard.reloadData()
            self.btnSave.status = self.viewModel.existsChanges() ? .enabled : .disabled
        }
    }
    
    func successGetStatus() {
        viewConfigure.isHidden = false
        viewError.isHidden = true
    }
    
    func failureGetStatus() {
        viewError.isHidden = false
        viewConfigure.isHidden = true
    }
}