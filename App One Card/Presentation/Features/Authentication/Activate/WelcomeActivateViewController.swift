//
//  WelcomeActivateViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 20/06/23.
//

import UIKit

class WelcomeActivateViewController: BaseViewController {

    @IBOutlet weak var btnActivate: PrimaryFilledButton!
    @IBOutlet weak var btnLater: PrimaryOutlineButton!
    
    private var viewModel: WelcomeActivateViewModelProtocol
    
    init(viewModel: WelcomeActivateViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        setupView()
    }

    private func setupView() {
        btnActivate.configure(text: "ACTIVAR", status: .enabled)
        btnLater.configure(text: "LO HARÉ LUEGO")
    }
    
    @IBAction func activate(_ sender: Any) {
        viewModel.toCardActivation()
    }
    
    @IBAction func later(_ sender: Any) {
        viewModel.toHome()
    }
}
