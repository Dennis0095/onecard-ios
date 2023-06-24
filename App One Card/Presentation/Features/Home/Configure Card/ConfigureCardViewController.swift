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
    @IBOutlet weak var btnSave: PrimaryFilledButton!
    
    private var viewModel: ConfigureCardViewModelProtocol
    
    init(viewModel: ConfigureCardViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        tbConfigureCard.delegate = self
        tbConfigureCard.dataSource = self
        
        tbConfigureCard.register(UINib(nibName: "ConfigureCardTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfigureCardTableViewCell")
        
        btnSave.configure(text: "GUARDAR CAMBIOS", status: .enabled)
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

extension ConfigureCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbConfigureCard.dequeueReusableCell(withIdentifier: "ConfigureCardTableViewCell", for: indexPath) as? ConfigureCardTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.configure(title: "APAGAR y PRENDER TARJETA", description: "Recuerde que no podrá hacer uso de su tarjeta mientras esté apagada.", isLast: (2 - 1) == indexPath.row)
        case 1:
            cell.configure(title: "Compras por internet", isLast: (2 - 1) == indexPath.row)
        default: break
        }
        
        return cell
    }
}

extension ConfigureCardViewController: UITableViewDelegate { }
