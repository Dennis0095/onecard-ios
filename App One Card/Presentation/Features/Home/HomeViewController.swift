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
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var stkOptions: UIStackView!
    @IBOutlet weak var imgQuestions: UIImageView!
    @IBOutlet weak var viewMovements: UIView!
    @IBOutlet weak var viewCardNotActivated: UIView!
    @IBOutlet weak var btnCardActivation: PrimaryFilledButton!
    
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
        viewMovements.isHidden = true
        viewCardNotActivated.isHidden = true
        
        tblMovements.register(UINib(nibName: "MovementTableViewCell", bundle: nil), forCellReuseIdentifier: "MovementTableViewCell")
        tblMovements.delegate = movementsDelegateDataSource
        tblMovements.dataSource = movementsDelegateDataSource
        
        [viewConfigureCard, viewCardLock, viewChangePin].forEach { view in
            view.addShadow(opacity: 0.08, offset: CGSize(width: 2, height: 4), radius: 8)
        }
        
        btnCardActivation.configure(text: "ACTIVAR TARJETA", status: .enabled)
        
        HomeObserver.shared.listenAmountChanges = { amount in
            self.lblAmount.text = amount
        }
        
        HomeObserver.shared.listenMovementsChanges = { movements in
            self.movementsViewModel.items = movements
            self.tblMovements.reloadData()
        }
        
        UserObserver.shared.listenChanges = { user in
            self.lblName.text = "BIENVENIDO \(user.name ?? "")"
        }
        
        CardObserver.shared.listenStatusChanges = { status in
            if status == "P" {
                self.stkOptions.isUserInteractionEnabled = false
                self.stkOptions.alpha = 0.5
                
                self.viewMovements.isHidden = true
                self.viewCardNotActivated.isHidden = false
            } else {
                self.stkOptions.isUserInteractionEnabled = true
                self.stkOptions.alpha = 1
                
                self.viewMovements.isHidden = false
                self.viewCardNotActivated.isHidden = true
                
                self.viewModel.consultMovements()
            }
        }
        
        viewModel.balanceInquiry()
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
    
    @IBAction func cardActivation(_ sender: Any) {
        print("Activa la tarjeta")
    }
}

extension HomeViewController: HomeViewModelDelegate { }
