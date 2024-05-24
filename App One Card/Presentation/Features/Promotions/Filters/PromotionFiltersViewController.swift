//
//  PromotionFiltersViewController.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import UIKit

class PromotionFiltersViewController: UIViewController {

    @IBOutlet weak var btnApply: PrimaryFilledButton!
    @IBOutlet weak var btnClear: PrimaryOutlineButton!
    @IBOutlet weak var tbFilters: UITableView!
    
    private let viewModel: PromotionFiltersViewModelProtocol
    private var promotionFiltersDelegateDataSource: PromotionFiltersDelegateDataSource
    
    init(viewModel: PromotionFiltersViewModelProtocol,
         promotionFiltersDelegateDataSource: PromotionFiltersDelegateDataSource) {
        self.viewModel = viewModel
        self.promotionFiltersDelegateDataSource = promotionFiltersDelegateDataSource
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnApply.configure(text: Constants.apply_filters, status: .enabled)
        btnClear.configure(text: Constants.clear_filters)
        
        tbFilters.delegate = promotionFiltersDelegateDataSource
        tbFilters.dataSource = promotionFiltersDelegateDataSource
        
        tbFilters.register(UINib(nibName: "PromotionFilterTableViewCell", bundle: nil), forCellReuseIdentifier: "PromotionFilterTableViewCell")
        tbFilters.register(UINib(nibName: "PromotionFilterHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "PromotionFilterHeaderTableViewCell")
        tbFilters.tableFooterView = nil
    }

    @IBAction func applyFilters(_ sender: Any) {
        self.dismiss(animated: true) {
            self.viewModel.applyFilters()
        }
    }
    
    @IBAction func clearFilters(_ sender: Any) {
        viewModel.clearFilters()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension PromotionFiltersViewController: PromotionFiltersViewModelDelegate {
    func expandedSection(section: Int) {
        tbFilters.beginUpdates()
        tbFilters.reloadSections(IndexSet(integer: section), with: .automatic)
        tbFilters.endUpdates()
    }
    
    func clearFilters() {
        tbFilters.reloadData()
    }
}
