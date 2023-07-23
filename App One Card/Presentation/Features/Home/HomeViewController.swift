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
    @IBOutlet weak var tblMovements: UITableView!
    
    private var viewModel: HomeViewModelProtocol
    private var movementsViewModel: MovementsViewModel
    private var movementsDelegateDataSource: MovementsDelegateDataSource
    
    init(viewModel: HomeViewModelProtocol, movementsViewModel: MovementsViewModel, movementsDelegateDataSource: MovementsDelegateDataSource) {
        self.viewModel = viewModel
        self.movementsViewModel = movementsViewModel
        self.movementsDelegateDataSource = movementsDelegateDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        tblMovements.register(UINib(nibName: "MovementTableViewCell", bundle: nil), forCellReuseIdentifier: "MovementTableViewCell")
        tblMovements.delegate = movementsDelegateDataSource
        tblMovements.dataSource = movementsDelegateDataSource
        
        [viewConfigureCard, viewCardLock, viewChangePin].forEach { view in
            view.addShadow(opacity: 0.08, offset: CGSize(width: 2, height: 4), radius: 8)
        }
        
        HomeObserver.shared.listenAmountChanges = { amount in
            self.lblAmount.text = amount
        }
        
        HomeObserver.shared.listenMovementsChanges = { movements in
            self.movementsViewModel.items = movements
            self.tblMovements.reloadData()
        }
        
        viewModel.balanceInquiry()
        viewModel.consultMovements()
    }

    override func setActions() {
        let tapConfigureCardLock = UITapGestureRecognizer(target: self, action: #selector(tapConfigureCardLock))
        viewConfigureCard.addGestureRecognizer(tapConfigureCardLock)
        
        let tapCardLock = UITapGestureRecognizer(target: self, action: #selector(tapCardLock))
        viewCardLock.addGestureRecognizer(tapCardLock)
        
        let tapChangePin = UITapGestureRecognizer(target: self, action: #selector(tapChangePin))
        viewChangePin.addGestureRecognizer(tapChangePin)
    }
    
    @objc
    func tapCardLock() {
        viewModel.toCardLock()
    }
    
    @objc
    func tapConfigureCardLock() {
        viewModel.toConfigureCard()
    }
    
    @objc
    func tapChangePin() {
        viewModel.toChangePin()
    }
}
