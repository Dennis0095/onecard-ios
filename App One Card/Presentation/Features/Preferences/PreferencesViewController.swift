//
//  PreferencesViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 10/06/23.
//

import UIKit

class PreferencesViewController: BaseViewController {

    @IBOutlet weak var tbPreferences: UITableView!
    
    private var preferencesList = [PreferenceItem]()
    
    private var viewModel: PreferencesViewModelProtocol
    
    init(viewModel: PreferencesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        tbPreferences.delegate = self
        tbPreferences.dataSource = self
        
        tbPreferences.register(UINib(nibName: "PreferencesTableViewCell", bundle: nil), forCellReuseIdentifier: "PreferencesTableViewCell")
        
        preferencesList = [
            PreferenceItem(id: 0, image: #imageLiteral(resourceName: "ic_profile.svg"), title: "Mi perfil"),
            PreferenceItem(id: 1, image: #imageLiteral(resourceName: "ic_question.svg"), title: "Preguntas frecuentes"),
            PreferenceItem(id: 2, image: #imageLiteral(resourceName: "ic_phone.svg"), title: "Contáctanos"),
            PreferenceItem(id: 3, image: #imageLiteral(resourceName: "ic_logout.svg"), title: "Cerrar sesión"),
        ]
    }
}

extension PreferencesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preferencesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbPreferences.dequeueReusableCell(withIdentifier: "PreferencesTableViewCell", for: indexPath) as? PreferencesTableViewCell else {
            return UITableViewCell()
        }
        
        let item = preferencesList[indexPath.row]
        cell.configure(item: item, isLast: (preferencesList.count - 1) == indexPath.row, image: item.image)
        
        return cell
    }
}

extension PreferencesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = preferencesList[indexPath.row]
        
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

struct PreferenceItem {
    let id: Int
    let image: UIImage
    let title: String
}
