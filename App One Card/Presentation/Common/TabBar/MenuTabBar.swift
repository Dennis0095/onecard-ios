//
//  MenuTabBar.swift
//  App One Card
//
//  Created by Paolo Arambulo on 10/06/23.
//

import UIKit

class MenuTabBar: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var homeTabBarItem: MenuTabBarItem!
    @IBOutlet weak var promotionsTabBarItem: MenuTabBarItem!
    @IBOutlet weak var configurationTabBarItem: MenuTabBarItem!
    
    var action: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupView()
        addActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setupView()
        addActions()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MenuTabBar", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupView() {
        homeTabBarItem.configure(title: Constants.tab_title_home, image: #imageLiteral(resourceName: "ic_home"), selectedImage: #imageLiteral(resourceName: "ic_home_selected"))
        promotionsTabBarItem.configure(title: Constants.tab_title_proms, image: #imageLiteral(resourceName: "ic_prom"), selectedImage: #imageLiteral(resourceName: "ic_prom_selected"))
        configurationTabBarItem.configure(title: Constants.tab_title_config, image: #imageLiteral(resourceName: "ic_configuration"), selectedImage: #imageLiteral(resourceName: "ic_configuration_selected"))
        
        homeTabBarItem.isSelectedItem = true
        
        contentView.addShadow(opacity: 0.15, offset: CGSize(width: 4, height: 0), radius: 8)
    }
    
    private func addActions() {
        homeTabBarItem.action = { [weak self] in
            self?.homeTabBarItem.isSelectedItem = true
            self?.promotionsTabBarItem.isSelectedItem = false
            self?.configurationTabBarItem.isSelectedItem = false
            
            if let handler = self?.action {
                handler(0)
            }
        }
        
        promotionsTabBarItem.action = { [weak self] in
            self?.homeTabBarItem.isSelectedItem = false
            self?.promotionsTabBarItem.isSelectedItem = true
            self?.configurationTabBarItem.isSelectedItem = false
            
            if let handler = self?.action {
                handler(1)
            }
        }
        
        configurationTabBarItem.action = { [weak self] in
            self?.homeTabBarItem.isSelectedItem = false
            self?.promotionsTabBarItem.isSelectedItem = false
            self?.configurationTabBarItem.isSelectedItem = true
            
            if let handler = self?.action {
                handler(2)
            }
        }
    }
}
