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
        tblPromotions.isHidden = true
        viewEmpty.isHidden = true
        
        tblPromotions.register(UINib(nibName: "PromotionTableViewCell", bundle: nil), forCellReuseIdentifier: "PromotionTableViewCell")
        tblPromotions.delegate = promotionsDelegateDataSource
        tblPromotions.dataSource = promotionsDelegateDataSource
        
        viewModel.fetchPromotions()
    }
    
}

extension PromotionsViewController: PromotionsViewModelDelegate {
    func showPromotions() {
        viewEmpty.isHidden = !viewModel.items.isEmpty
        tblPromotions.isHidden = viewModel.items.isEmpty
        
        tblPromotions.reloadData()
    }
}
