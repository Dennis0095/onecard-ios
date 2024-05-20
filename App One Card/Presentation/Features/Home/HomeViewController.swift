//
//  HomeViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 10/06/23.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var viewOneCard: UIView!
    @IBOutlet weak var viewCardLock: UIView!
    @IBOutlet weak var viewConfigureCard: UIView!
    @IBOutlet weak var viewChangePin: UIView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var tblMovements: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var stkOptions: UIStackView!
    @IBOutlet weak var imgQuestions: UIImageView!
    @IBOutlet weak var viewMovements: UIView!
    @IBOutlet weak var viewCardNotActivated: UIView!
    @IBOutlet weak var viewInfoCardLock: UIView!
    @IBOutlet weak var btnCardActivation: PrimaryFilledButton!
    @IBOutlet weak var vBanners: UIView!
    @IBOutlet weak var cvBanners: UICollectionView!
    @IBOutlet weak var btnMoveToLeft: UIButton!
    @IBOutlet weak var btnMoveToRight: UIButton!
    
    private var viewModel: HomeViewModelProtocol
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        vBanners.isHidden = true
        viewMovements.isHidden = true
        viewCardNotActivated.isHidden = true
        
        tblMovements.register(UINib(nibName: "MovementTableViewCell", bundle: nil), forCellReuseIdentifier: "MovementTableViewCell")
        tblMovements.delegate = self
        tblMovements.dataSource = self
        
        cvBanners.register(UINib(nibName: "BannerCell", bundle: nil), forCellWithReuseIdentifier: "BannerCell")
        cvBanners.delegate = self
        cvBanners.dataSource = self
        
        if let flowLayout = cvBanners.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        
        imgQuestions.addShadow(color: UIColor(hexString: "#E6E9EF"), radius: 10)
        
        [viewOneCard, viewConfigureCard, viewCardLock, viewChangePin].forEach { view in
            view?.layer.cornerRadius = 4
            view?.addShadow(opacity: 0.08, offset: CGSize(width: 2, height: 4), radius: 8)
        }
        
        imgQuestions.addShadow(color: UIColor(red: 0.902, green: 0.914, blue: 0.937, alpha: 1), opacity: 1, offset: CGSize(width: 0, height: 6), radius: 5)
        btnCardActivation.configure(text: "Activar Tarjeta", status: .enabled)
        lblName.text = "\(Constants.welcome), \(UserObserver.shared.getUser()?.name ?? "")"
        validateStatus()
        
        HomeObserver.shared.listenAmountChanges = { amount in
            self.lblAmount.text = amount
        }
        
        HomeObserver.shared.listenMovementsChanges = { movements in
            //First 3 items
            self.viewModel.items = Array(movements.prefix(3))
            DispatchQueue.main.async {
                self.tblMovements.reloadData()
            }
        }
        
        UserObserver.shared.listenChanges = { user in
            self.lblName.text = "\(Constants.welcome), \(user.name ?? "")"
        }
        
        CardObserver.shared.listenStatusChanges = { status in
            self.validateStatus()
        }
        
        self.viewModel.consultBanners()
    }
    
    override func setActions() {
        let tapConfigureCardLock = UITapGestureRecognizer(target: self, action: #selector(tapConfigureCardLock))
        viewConfigureCard.addGestureRecognizer(tapConfigureCardLock)
        
        let tapCardLock = UITapGestureRecognizer(target: self, action: #selector(tapCardLock))
        viewCardLock.addGestureRecognizer(tapCardLock)
        
        let tapChangePin = UITapGestureRecognizer(target: self, action: #selector(tapChangePin))
        viewChangePin.addGestureRecognizer(tapChangePin)
        
        let tapFrequenQuestions = UITapGestureRecognizer(target: self, action: #selector(tapFrequentQuestions))
        imgQuestions.addGestureRecognizer(tapFrequenQuestions)
    }
    
    private func validateStatus() {
        let status = CardObserver.shared.getStatus()
        if status == .NOT_ACTIVE {
            self.stkOptions.isUserInteractionEnabled = false
            self.stkOptions.alpha = 0.5
            
            self.viewMovements.isHidden = true
            self.viewCardNotActivated.isHidden = false
            self.viewInfoCardLock.isHidden = true
        } else if status == .CANCEL {
            self.stkOptions.isUserInteractionEnabled = false
            self.stkOptions.alpha = 0.5
            
            self.viewMovements.isHidden = false
            self.viewCardNotActivated.isHidden = true
            self.viewInfoCardLock.isHidden = false
            
            self.viewModel.balanceInquiry()
            self.viewModel.consultMovements()
        } else if status == .ACTIVE || status == .TEMPORARY_LOCKED {
            self.stkOptions.isUserInteractionEnabled = true
            self.stkOptions.alpha = 1
            
            self.viewMovements.isHidden = false
            self.viewCardNotActivated.isHidden = true
            self.viewInfoCardLock.isHidden = true
            
            self.viewModel.balanceInquiry()
            self.viewModel.consultMovements()
        }
    }
    
    @objc
    func tapCardLock() {
        viewModel.toCardLock()
    }
    
    @objc
    func tapConfigureCardLock() {
        viewModel.toConfigureCard()
    }
    
    @objc
    func tapChangePin() {
        viewModel.toChangePin()
    }
    
    @objc
    func tapFrequentQuestions() {
        viewModel.toFrequentQuestions()
    }
    
    @objc
    func scrollToNextItem() {
        let visibleItemsIndexPaths = cvBanners.indexPathsForVisibleItems
        if let lastIndexPath = visibleItemsIndexPaths.last, lastIndexPath.item < viewModel.banners.count - 1 {
            let nextIndexPath = IndexPath(item: lastIndexPath.item + 1, section: lastIndexPath.section)
            cvBanners.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        } else if let lastIndexPath = visibleItemsIndexPaths.last, lastIndexPath.item == viewModel.banners.count - 1 {
            let nextIndexPath = IndexPath(item: 0, section: lastIndexPath.section)
            cvBanners.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func toMovements(_ sender: Any) {
        viewModel.toMovements()
    }
    
    @IBAction func cardActivation(_ sender: Any) {
        viewModel.toCardActivation()
    }
    
    @IBAction func moveToLeft(_ sender: Any) {
        let visibleItemsIndexPaths = cvBanners.indexPathsForVisibleItems
        if let firstIndexPath = visibleItemsIndexPaths.first, firstIndexPath.item > 0 {
            let previousIndexPath = IndexPath(item: firstIndexPath.item - 1, section: firstIndexPath.section)
            cvBanners.scrollToItem(at: previousIndexPath, at: .centeredHorizontally, animated: true)
        } else if let firstIndexPath = visibleItemsIndexPaths.first, firstIndexPath.item == 0 {
            let nextIndexPath = IndexPath(item: viewModel.banners.count - 1, section: firstIndexPath.section)
            cvBanners.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func moveToRight(_ sender: Any) {
        scrollToNextItem()
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func showBanners(isEmpty: Bool) {
        DispatchQueue.main.async {
            self.vBanners.isHidden = isEmpty
            self.cvBanners.reloadData()
            
            self.btnMoveToLeft.isHidden = self.viewModel.banners.count < 2
            self.btnMoveToRight.isHidden = self.viewModel.banners.count < 2
            
            self.viewModel.timerBanners?.invalidate()
            self.viewModel.timerBanners = self.viewModel.banners.count > 1 ? Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.scrollToNextItem), userInfo: nil, repeats: true) : nil
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovementTableViewCell", for: indexPath) as? MovementTableViewCell else {
            return UITableViewCell()
        }
        
        let movement = viewModel.items[indexPath.row]
        cell.setData(movement: movement)
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movement = viewModel.items[indexPath.row]
        viewModel.selectItem(movement: movement)
    }
}

extension HomeViewController: UICollectionViewDelegate { 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let banner = viewModel.banners[indexPath.row]
        if let url = URL(string: banner.link ?? "") {
            UIApplication.shared.open(url)
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 146)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = cvBanners.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as? BannerCell else {
            return UICollectionViewCell()
        }
        
        let banner = viewModel.banners[indexPath.row]
        cell.setData(banner: banner)
        
        return cell
    }
}
