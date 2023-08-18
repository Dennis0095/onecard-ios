//
//  FrequentQuestionsViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/06/23.
//

import UIKit

class FrequentQuestionsViewController: BaseViewController {
    
    @IBOutlet weak var tbQuestions: UITableView!
    @IBOutlet weak var imgBack: UIImageView!
    
    private var viewModel: FrequentQuestionsViewModelProtocol
    private var frequentQuestionsDelegateDataSource: FrequentQuestionsDelegateDataSource
    
    init(viewModel: FrequentQuestionsViewModelProtocol, frequentQuestionsDelegateDataSource: FrequentQuestionsDelegateDataSource) {
        self.viewModel = viewModel
        self.frequentQuestionsDelegateDataSource = frequentQuestionsDelegateDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        tbQuestions.delegate = frequentQuestionsDelegateDataSource
        tbQuestions.dataSource = frequentQuestionsDelegateDataSource
        
        tbQuestions.register(UINib(nibName: "FrequentQuestionsTableViewCell", bundle: nil), forCellReuseIdentifier: "FrequentQuestionsTableViewCell")
        
        viewModel.fetchFrequentQuestions()
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
}

extension FrequentQuestionsViewController: FrequentQuestionsViewModelDelegate {
    func showQuestions() {
        DispatchQueue.main.async {
            self.tbQuestions.reloadData()
        }
    }
}
