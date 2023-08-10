//
//  MovementDetailViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 10/08/23.
//

import UIKit

class MovementDetailViewController: BaseViewController {
    
    @IBOutlet weak var imgBack: UIImageView!
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
    }
    
    @objc
    private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
