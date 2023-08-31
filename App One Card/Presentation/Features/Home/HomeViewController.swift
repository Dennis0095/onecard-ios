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
    @IBOutlet weak var viewInfoCardLock: UIView!
    @IBOutlet weak var btnCardActivation: PrimaryFilledButton!
    
    private var viewModel: HomeViewModelProtocol
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        viewMovements.isHidden = true
        viewCardNotActivated.isHidden = true
        
        tblMovements.register(UINib(nibName: "MovementTableViewCell", bundle: nil), forCellReuseIdentifier: "MovementTableViewCell")
        tblMovements.delegate = self
        tblMovements.dataSource = self
        
        [viewConfigureCard, viewCardLock, viewChangePin].forEach { view in
            view.addShadow(opacity: 0.08, offset: CGSize(width: 2, height: 4), radius: 8)
        }
        
        imgQuestions.addShadow(color: UIColor(red: 0.902, green: 0.914, blue: 0.937, alpha: 1), opacity: 1, offset: CGSize(width: 0, height: 6), radius: 5)
        btnCardActivation.configure(text: "Activar Tarjeta", status: .enabled)
        lblName.text = "BIENVENIDO \(UserObserver.shared.getUser()?.name ?? "")"
        validateStatus(CardObserver.shared.getStatus())
        
        HomeObserver.shared.listenAmountChanges = { amount in
            self.lblAmount.text = amount
        }
        
        HomeObserver.shared.listenMovementsChanges = { movements in
            self.viewModel.items = movements
            DispatchQueue.main.async {
                self.tblMovements.reloadData()
            }
        }
        
        UserObserver.shared.listenChanges = { user in
            self.lblName.text = "BIENVENIDO \(user.name ?? "")"
        }
        
        CardObserver.shared.listenStatusChanges = { status in
            self.validateStatus(status)
        }
    }
    
    override func setActions() {
        let tapConfigureCardLock = UITapGestureRecognizer(target: self, action: #selector(tapConfigureCardLock))
        viewConfigureCard.addGestureRecognizer(tapConfigureCardLock)
        
        let tapCardLock = UITapGestureRecognizer(target: self, action: #selector(tapCardLock))
        viewCardLock.addGestureRecognizer(tapCardLock)
        
        let tapChangePin = UITapGestureRecognizer(target: self, action: #selector(tapChangePin))
        viewChangePin.addGestureRecognizer(tapChangePin)
    }
    
    private func validateStatus(_ status: StatusCard?) {
        if status == .NOT_ACTIVE {
            self.stkOptions.isUserInteractionEnabled = false
            self.stkOptions.alpha = 0.5
            
            self.viewMovements.isHidden = true
            self.viewCardNotActivated.isHidden = false
            self.viewInfoCardLock.isHidden = true
        } else if status == .CANCEL {
            self.stkOptions.isUserInteractionEnabled = false
            self.stkOptions.alpha = 0.5
            
            self.viewMovements.isHidden = false
            self.viewCardNotActivated.isHidden = true
            self.viewInfoCardLock.isHidden = false
            
            self.viewModel.balanceInquiry()
            self.viewModel.consultMovements()
        } else if status == .ACTIVE || status == .TEMPORARY_LOCKED {
            self.stkOptions.isUserInteractionEnabled = true
            self.stkOptions.alpha = 1
            
            self.viewMovements.isHidden = false
            self.viewCardNotActivated.isHidden = true
            self.viewInfoCardLock.isHidden = true
            
            self.viewModel.balanceInquiry()
            self.viewModel.consultMovements()
        }
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
    
    @IBAction func toMovements(_ sender: Any) {
        viewModel.toMovements()
    }
    
    @IBAction func cardActivation(_ sender: Any) {
        viewModel.toCardActivation()
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movement = viewModel.items[indexPath.row]
        viewModel.selectItem(movement: movement)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovementTableViewCell", for: indexPath) as? MovementTableViewCell else {
            return UITableViewCell()
        }
        
        let movement = viewModel.items[indexPath.row]
        cell.setData(movement: movement)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {}
