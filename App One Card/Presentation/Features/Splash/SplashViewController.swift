//
//  SplashViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

class SplashViewController: UIViewController {

    private var splashViewModel: SplashViewModelProtocol
    
    init(splashViewModel: SplashViewModelProtocol) {
        self.splashViewModel = splashViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splashViewModel.validateLoginStatus()

//        if splashViewModel.isLoggedIn {
//            // User is logged in, proceed with the app flow
//            
//        } else {
//            // User is not logged in, show login screen or take appropriate action
//            
//        }
    }
}
