//
//  MovementsViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 9/08/23.
//

import UIKit

class MovementsViewController: BaseViewController {

    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var viewMovements: UIView!
    @IBOutlet weak var tblMovements: UITableView!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblTitleError: UILabel!
    @IBOutlet weak var lblMessageError: UILabel!
    @IBOutlet weak var btnTryAgain: PrimaryFilledButton!
    
    private var viewModel: MovementsViewModelProtocol
    private var movementsDelegateDataSource: MovementsDelegateDataSource
    
    init(viewModel: MovementsViewModelProtocol, movementsDelegateDataSource: MovementsDelegateDataSource) {
        self.viewModel = viewModel
        self.movementsDelegateDataSource = movementsDelegateDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        viewError.isHidden = true
        viewMovements.isHidden = true
        
        tblMovements.delegate = movementsDelegateDataSource
        tblMovements.dataSource = movementsDelegateDataSource
        
        tblMovements.register(UINib(nibName: "MovementTableViewCell", bundle: nil), forCellReuseIdentifier: "MovementTableViewCell")
        
        btnTryAgain.configure(text: Constants.try_again, status: .enabled)
        
        viewModel.consultMovements()
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
    }
    
    @objc
    private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tryAgain(_ sender: Any) {
    }
    
}

extension MovementsViewController: MovementsViewModelDelegate {
    
    func successGetMovements() {
        DispatchQueue.main.async {
            self.tblMovements.reloadData()
            
            self.viewMovements.isHidden = false
            self.viewError.isHidden = true
        }
    }
    
    func failureGetMovements(error: APIError) {
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
            self.viewMovements.isHidden = true
        }
    }
    
}
