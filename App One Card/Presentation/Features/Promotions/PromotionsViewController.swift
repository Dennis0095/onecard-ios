//
//  PromotionsViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 19/07/23.
//

import UIKit

class PromotionsViewController: BaseViewController {

    @IBOutlet weak var tblPromotions: UITableView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var viewPromotions: UIView!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblTitleError: UILabel!
    @IBOutlet weak var lblMessageError: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnTryAgain: PrimaryFilledButton!
    @IBOutlet weak var btnSearch: UIButton!
    
    private var viewModel: PromotionsViewModelProtocol
    private var promotionsDelegateDataSource: PromotionsDelegateDataSource
    
    init(viewModel: PromotionsViewModelProtocol, promotionsDelegateDataSource: PromotionsDelegateDataSource) {
        self.viewModel = viewModel
        self.promotionsDelegateDataSource = promotionsDelegateDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initView() {
        viewPromotions.isHidden = true
        viewError.isHidden = true
        
        btnTryAgain.configure(text: Constants.try_again, status: .enabled)
        
        tblPromotions.register(UINib(nibName: "PromotionTableViewCell", bundle: nil), forCellReuseIdentifier: "PromotionTableViewCell")
        tblPromotions.delegate = promotionsDelegateDataSource
        tblPromotions.dataSource = promotionsDelegateDataSource
        
        btnSearch.layer.cornerRadius = 8
        txtSearch.delegate = self
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        viewModel.paginate()
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        viewModel.filter = textField.text ?? ""
        if textField.text?.isEmpty ?? false {
            textField.resignFirstResponder()
            textField.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                textField.isEnabled = true
            }
            viewModel.filterPromotions()
        }
    }
    
    @IBAction func tryAgain(_ sender: Any) {
        viewModel.paginate()
    }
    
    @IBAction func searchPromotions(_ sender: Any) {
        guard !viewModel.filter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, viewModel.filter.count > 2 else { return }
        
        txtSearch.resignFirstResponder()
        viewModel.filterPromotions()
    }
}

extension PromotionsViewController: PromotionsViewModelDelegate {
    func showPromotions() {
        DispatchQueue.main.async {
            self.viewError.isHidden = true
            self.viewPromotions.isHidden = false
            
            self.tblPromotions.isHidden = self.viewModel.items.isEmpty
            self.viewEmpty.isHidden = !self.viewModel.items.isEmpty
            
            self.tblPromotions.reloadData()
        }
    }
    
    func failureShowPromotions(error: APIError) {
        DispatchQueue.main.async {
            self.lblTitleError.text = error.error().title
            self.lblMessageError.text = error.error().description
            
            switch error {
            case .networkError:
                self.imgError.image = #imageLiteral(resourceName: "connection_error_blue.svg")
            default:
                self.imgError.image = #imageLiteral(resourceName: "something_went_wrong_blue.svg")
            }
            
            self.viewError.isHidden = false
            self.viewPromotions.isHidden = true
        }
    }
}

extension PromotionsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtSearch.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if prospectiveText.count > 100 {
            return false
        }
        
        let allowedCharacters = CharacterSet.alphanumerics
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
