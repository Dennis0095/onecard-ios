//
//  PromotionDetailViewController.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 11/05/24.
//

import UIKit

class PromotionDetailViewController: UIViewController {

    @IBOutlet weak var viewClose: UIView!
    @IBOutlet weak var viewPlace: UIView!
    @IBOutlet weak var viewValidity: UIView!
    @IBOutlet weak var viewTermsConditions: UIView!
    @IBOutlet weak var ivPromotion: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPromotion: UILabel!
    @IBOutlet weak var lblPlaces: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
    @IBOutlet weak var lblClose: UILabel!
    @IBOutlet weak var viewPromotion: UIView!
    
    private let viewModel: PromotionDetailViewModelProtocol
    private let priceFormatter = NumberFormatter()
    
    init(viewModel: PromotionDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        priceFormatter.minimumIntegerDigits = 1
        priceFormatter.minimumFractionDigits = 2
        
        setCornerRadius()
        addActions()
        
        viewModel.onAppear()
    }
    
    private func addActions() {
        let tapClose = UITapGestureRecognizer(target: self, action: #selector(tapClose))
        viewClose.isUserInteractionEnabled = true
        viewClose.addGestureRecognizer(tapClose)
        
        let tapTermsConditions = UITapGestureRecognizer(target: self, action: #selector(tapTermsConditions))
        viewTermsConditions.isUserInteractionEnabled = true
        viewTermsConditions.addGestureRecognizer(tapTermsConditions)
    }
    
    @objc
    private func tapClose() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func tapTermsConditions() {
        viewModel.showTerms()
    }
    
    private func setCornerRadius() {
        ivPromotion.clipsToBounds = true
        ivPromotion.layer.cornerRadius = 10
        
        [viewValidity, viewTermsConditions, viewPlace, viewPromotion].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 5
        }
        viewClose.clipsToBounds = true
        viewClose.layer.cornerRadius = viewClose.frame.height / 2
    }
    
    private func validatePromotion(detail: PromotionDetailResponse) {
        if detail.applyPrice == 1 {
            let price = NSNumber(floatLiteral: detail.price ?? 0.0)
            lblPromotion.text = "S/ \(priceFormatter.string(from: price)!)"
            
            viewPromotion.isHidden = false
            viewPromotion.backgroundColor = #colorLiteral(red: 0, green: 0.2980392157, blue: 0.5921568627, alpha: 1)
        } else if detail.applyDiscount == 1 {
            lblPromotion.text = "\(Int(detail.discountRate ?? 0.0)) % DSCTO."
            
            viewPromotion.isHidden = false
            viewPromotion.backgroundColor = #colorLiteral(red: 0, green: 0.6392156863, blue: 0.8784313725, alpha: 1)
        } else {
            viewPromotion.isHidden = true
        }
    }

}

extension PromotionDetailViewController: PromotionDetailViewModelDelegate {
    func showInfoDetail(detail: PromotionDetailResponse) {
        ivPromotion.base64ToImage(base64String: detail.promotionImage ?? "")
        lblTitle.text = detail.detailTitle
        lblSubtitle.text = detail.detailSubtitle
        lblDescription.text = detail.detailDescription
        lblPlaces.text = detail.exchangePlace
        lblValidity.text = detail.validity
        
        validatePromotion(detail: detail)
    }
}
