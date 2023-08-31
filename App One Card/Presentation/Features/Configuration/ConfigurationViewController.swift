//
//  ConfigurationViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 10/06/23.
//

import UIKit

class ConfigurationViewController: BaseViewController {

    @IBOutlet weak var tblConfiguration: UITableView!
    
    private var configurationList = [ConfigurationItem]()
    
    private var viewModel: ConfigurationViewModelProtocol
    
    init(viewModel: ConfigurationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        tblConfiguration.delegate = self
        tblConfiguration.dataSource = self
        
        tblConfiguration.register(UINib(nibName: "ConfigurationTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfigurationTableViewCell")
        
        configurationList = [
            ConfigurationItem(id: 0, image: #imageLiteral(resourceName: "ic_profile.svg"), title: "Mi perfil"),
            ConfigurationItem(id: 1, image: #imageLiteral(resourceName: "ic_question.svg"), title: "Preguntas frecuentes"),
            //ConfigurationItem(id: 2, image: #imageLiteral(resourceName: "ic_phone.svg"), title: "Contáctanos"),
            ConfigurationItem(id: 3, image: #imageLiteral(resourceName: "ic_logout.svg"), title: "Cerrar sesión"),
        ]
    }
}

extension ConfigurationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configurationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblConfiguration.dequeueReusableCell(withIdentifier: "ConfigurationTableViewCell", for: indexPath) as? ConfigurationTableViewCell else {
            return UITableViewCell()
        }
        
        let item = configurationList[indexPath.row]
        cell.configure(item: item, isLast: (configurationList.count - 1) == indexPath.row, image: item.image)
        
        return cell
    }
}

extension ConfigurationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = configurationList[indexPath.row]
        
        switch item.id {
        case 0:
            viewModel.toProfile()
        case 1:
            viewModel.toQuestions()
        case 2:
            viewModel.toContact(phoneNumber: "016151111")
        case 3:
            viewModel.confirmLogout()
        default: break
        }
    }
}

struct ConfigurationItem {
    let id: Int
    let image: UIImage
    let title: String
}
