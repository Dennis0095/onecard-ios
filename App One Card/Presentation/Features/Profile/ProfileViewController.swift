//
//  ProfileViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/06/23.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var lblDocument: UILabel!
    @IBOutlet weak var lblCellphone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblRUC: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnTryAgain: PrimaryFilledButton!
    
    private var viewModel: ProfileViewModelProtocol

    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        viewError.isHidden = true
        viewProfile.isHidden = true
        
        btnTryAgain.configure(text: "VOLVER A INTENTAR", status: .enabled)
        
        viewModel.getUserData()
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
    }
    
    private func getDocumentType(id: String) -> String {
        switch id {
        case "1":
            return "DNI"
        case "2":
            return "CARNET EXTRANJERÍA"
        case "3":
            return "PASAPORTE"
        case "5":
            return "RUC"
        case "7":
            return "PTP"
        default:
            return ""
        }
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
        viewModel.toEditPassword()
    }
    
    @IBAction func tryAgain(_ sender: Any) {
        viewModel.getUserData()
    }
}

extension ProfileViewController: ProfileViewModelDelegate {
    func showData(user: ConsultUserDataResponse) {
        DispatchQueue.main.async {
            self.lblName.text = ((user.name ?? "") + " " + (user.lastName ?? "")).trimmingCharacters(in: .whitespaces)
            self.lblBirthday.text = user.birthday ?? ""
            self.lblDocument.text = ((self.getDocumentType(id: user.docType ?? "")) + " " + (user.docNumber ?? "")).trimmingCharacters(in: .whitespaces)
            self.lblCellphone.text = user.truncatedCellphone ?? ""
            self.lblEmail.text = user.email ?? ""
            self.lblRUC.text = user.companyRUC ?? ""
            self.lblUsername.text = user.userName ?? ""
            
            self.viewError.isHidden = true
            self.viewProfile.isHidden = false
        }
    }
    
    func failureShowData() {
        DispatchQueue.main.async {
            self.viewError.isHidden = false
            self.viewProfile.isHidden = true
        }
    }
}
