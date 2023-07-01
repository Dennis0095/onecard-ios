//
//  HomeViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 10/06/23.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var viewCardLock: UIView!
    @IBOutlet weak var viewConfigureCard: UIView!
    @IBOutlet weak var viewChangePin: UIView!
    @IBOutlet weak var lblAmount: UILabel!
    
    private var viewModel: HomeViewModelProtocol
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        [viewConfigureCard, viewCardLock, viewChangePin].forEach { view in
            view.addShadow(opacity: 0.08, offset: CGSize(width: 2, height: 4), radius: 8)
        }
        
        viewModel.balanceInquiry()
        
        HomeObserver.shared.listenAmountChanges = { amount in
            self.lblAmount.text = amount
        }
    }

    override func setActions() {
        let tapConfigureCardLock = UITapGestureRecognizer(target: self, action: #selector(tapConfigureCardLock))
        viewConfigureCard.addGestureRecognizer(tapConfigureCardLock)
        
        let tapCardLock = UITapGestureRecognizer(target: self, action: #selector(tapCardLock))
        viewCardLock.addGestureRecognizer(tapCardLock)
    }
    
    @objc
    func tapCardLock() {
        viewModel.toCardLock()
    }
    
    @objc
    func tapConfigureCardLock() {
        viewModel.toConfigureCard()
    }
}
