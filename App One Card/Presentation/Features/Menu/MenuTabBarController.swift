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
    var authRouter: AuthenticationRouterDelegate
    var configurationRouter: ConfigurationRouterDelegate
    var promotionsRouter: PromotionsRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    
    init(homeRouter: HomeRouterDelegate, authRouter: AuthenticationRouterDelegate, configurationRouter: ConfigurationRouterDelegate, successfulRouter: SuccessfulRouterDelegate, promotionsRouter: PromotionsRouterDelegate) {
        self.homeRouter = homeRouter
        self.authRouter = authRouter
        self.configurationRouter = configurationRouter
        self.successfulRouter = successfulRouter
        self.promotionsRouter = promotionsRouter
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
        
        let promViewController = setupPromotions()
        
        let configurationViewModel = ConfigurationViewModel()
        configurationViewModel.router = configurationRouter
        let configurationViewController = ConfigurationViewController(viewModel: configurationViewModel)
        
        viewControllers = [homeViewController, promViewController, configurationViewController]
        
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
        let bannersRepository = BannersDataRepository()
        let bannersUseCase = BannersUseCase(bannersRepository: bannersRepository)
        let viewModel = HomeViewModel(router: homeRouter, authRouter: authRouter, successfulRouter: successfulRouter, balanceUseCase: useCase, movementUseCase: movementUseCase, bannersUseCase: bannersUseCase)
        let home = HomeViewController(viewModel: viewModel)
        viewModel.delegate = home
        return home
    }
    
    private func setupPromotions() -> PromotionsViewController {
        let promotionRepository = PromotionDataRepository()
        let promotionUseCase = PromotionUseCase(promotionRepository: promotionRepository)
        let viewModel = PromotionsViewModel(router: promotionsRouter, promotionUseCase: promotionUseCase)
        let promotionsDelegateDataSource = PromotionsDelegateDataSource(viewModel: viewModel)
        let promotions = PromotionsViewController(viewModel: viewModel, promotionsDelegateDataSource: promotionsDelegateDataSource)
        viewModel.delegate = promotions
        return promotions
    }
    
    private func addActions() {
        menuTabBar.action = { [weak self] index in
            self?.selectedIndex = index
        }
    }
}
