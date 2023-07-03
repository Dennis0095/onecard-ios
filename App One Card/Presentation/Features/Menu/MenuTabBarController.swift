//
//  MenuTabBarController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 10/06/23.
//

fileprivate var menuTabBarHeight: CGFloat = 66

import UIKit

class MenuTabBarController: UITabBarController {

    private lazy var menuTabBar: MenuTabBar = {
        let tabBar = MenuTabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    var homeRouter: HomeRouterDelegate
    var preferencesRouter: PreferencesRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    
    init(homeRouter: HomeRouterDelegate, preferencesRouter: PreferencesRouterDelegate, successfulRouter: SuccessfulRouterDelegate) {
        self.homeRouter = homeRouter
        self.preferencesRouter = preferencesRouter
        self.successfulRouter = successfulRouter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        addActions()
    }
    
    private func setupView() {
        let homeViewController = setupHome()
        
        let promViewController = UIViewController()
        
        let preferencesViewModel = PreferencesViewModel()
        preferencesViewModel.router = preferencesRouter
        let preferencesViewController = PreferencesViewController(viewModel: preferencesViewModel)
        
        viewControllers = [homeViewController, promViewController, preferencesViewController]
        
        view.addSubview(menuTabBar)
        
        NSLayoutConstraint.activate([
            menuTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        tabBar.isHidden = true
        if let viewControllers = viewControllers {
            for viewController in viewControllers {
                viewController.additionalSafeAreaInsets.bottom = menuTabBarHeight
            }
        }
    }

    private func setupHome() -> HomeViewController {
        let repository = BalanceDataRepository()
        let useCase = BalanceUseCase(balanceRepository: repository)
        let movementRepository = MovementDataRepository()
        let movementUseCase = MovementUseCase(movementRepository: movementRepository)
        let viewModel = HomeViewModel(router: homeRouter, successfulRouter: successfulRouter, balanceUseCase: useCase, movementUseCase: movementUseCase)
        let home = HomeViewController(viewModel: viewModel)
        return home
    }
    
    private func addActions() {
        menuTabBar.action = { [weak self] index in
            self?.selectedIndex = index
        }
    }
}
