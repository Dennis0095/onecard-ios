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
    
    //    private var viewModel: ConfigureCardViewModelProtocol
    //
    //    init(viewModel: ConfigureCardViewModelProtocol) {
    //        self.viewModel = viewModel
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    override func initView() {
        tbQuestions.delegate = self
        tbQuestions.dataSource = self
        
        tbQuestions.register(UINib(nibName: "FrequentQuestionsTableViewCell", bundle: nil), forCellReuseIdentifier: "FrequentQuestionsTableViewCell")
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

extension FrequentQuestionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbQuestions.dequeueReusableCell(withIdentifier: "FrequentQuestionsTableViewCell", for: indexPath) as? FrequentQuestionsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.handleBreakDown = {
            self.tbQuestions.beginUpdates()
            self.tbQuestions.endUpdates()
        }
        
        return cell
    }
    
//    tableView.beginUpdates()
//    tableView.endUpdates()
}

extension FrequentQuestionsViewController: UITableViewDelegate { }

//final class ContentSizedTableView: UITableView {
//    override var contentSize:CGSize {
//        didSet {
//            invalidateIntrinsicContentSize()
//        }
//    }
//
//    override var intrinsicContentSize: CGSize {
//        layoutIfNeeded()
//        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
//    }
//}
