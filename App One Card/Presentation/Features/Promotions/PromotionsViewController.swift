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
    @IBOutlet weak var btnTryAgain: PrimaryFilledButton!
    
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
        viewEmpty.isHidden = true
        viewError.isHidden = true
        
        btnTryAgain.configure(text: "VOLVER A INTENTAR", status: .enabled)
        
        tblPromotions.register(UINib(nibName: "PromotionTableViewCell", bundle: nil), forCellReuseIdentifier: "PromotionTableViewCell")
        tblPromotions.delegate = promotionsDelegateDataSource
        tblPromotions.dataSource = promotionsDelegateDataSource
        
        viewModel.fetchPromotions()
    }
    
    @IBAction func tryAgain(_ sender: Any) {
        viewModel.fetchPromotions()
    }
    
}

extension PromotionsViewController: PromotionsViewModelDelegate {
    func showPromotions() {
        DispatchQueue.main.async {
            self.viewError.isHidden = true
            self.viewEmpty.isHidden = !self.viewModel.items.isEmpty
            self.viewPromotions.isHidden = self.viewModel.items.isEmpty
            
            self.tblPromotions.reloadData()
        }
    }
    
    func failureShowPromotions(error: APIError) {
        DispatchQueue.main.async {
            self.lblTitleError.text = error.error().title
            self.lblMessageError.text = error.error().description
            
            switch error {
            case .networkError:
                self.imgError.image = #imageLiteral(resourceName: "connection_error_white.svg")
            default:
                self.imgError.image = #imageLiteral(resourceName: "something_went_wrong_white.svg")
            }
            
            self.viewError.isHidden = false
            self.viewPromotions.isHidden = true
            self.viewEmpty.isHidden = true
        }
    }
}
