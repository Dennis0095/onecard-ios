//
//  HomeViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 10/06/23.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var viewCardLock: UIView!
    @IBOutlet weak var viewConfigureCard: UIView!
    @IBOutlet weak var viewChangePin: UIView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var tblMovements: UITableView!
    
    private var viewModel: HomeViewModelProtocol
    private let movementsViewModel = MovementsViewModel()
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        tblMovements.register(UINib(nibName: "MovementTableViewCell", bundle: nil), forCellReuseIdentifier: "MovementTableViewCell")
        tblMovements.delegate = movementsViewModel
        tblMovements.dataSource = movementsViewModel
        
        [viewConfigureCard, viewCardLock, viewChangePin].forEach { view in
            view.addShadow(opacity: 0.08, offset: CGSize(width: 2, height: 4), radius: 8)
        }
        
        HomeObserver.shared.listenAmountChanges = { amount in
            self.lblAmount.text = amount
        }
        
        HomeObserver.shared.listenMovementsChanges = { movements in
            self.movementsViewModel.movements = movements
            self.tblMovements.reloadData()
        }
        
        viewModel.balanceInquiry()
        viewModel.consultMovements()
    }

    override func setActions() {
        let tapConfigureCardLock = UITapGestureRecognizer(target: self, action: #selector(tapConfigureCardLock))
        viewConfigureCard.addGestureRecognizer(tapConfigureCardLock)
        
        let tapCardLock = UITapGestureRecognizer(target: self, action: #selector(tapCardLock))
        viewCardLock.addGestureRecognizer(tapCardLock)
    }
    
    @objc
    func tapCardLock() {
        viewModel.toCardLock()
    }
    
    @objc
    func tapConfigureCardLock() {
        viewModel.toConfigureCard()
    }
}

//class MissionsDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
//
//    var missions = [MissionEntity]()
//    var dataContentTypeMissions: [DataContentType]?
//    var dataContentTypeBought: [DataContentType]?
//    var dataContentTypeReedem: [DataContentType]?
//
//    var view: MissionsDataSourceView!
//    var countedFired: CGFloat = 0
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.missions.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let mission = missions[indexPath.row]
//        let missionCard = self.dataContentTypeMissions?.first(where: {
//            $0.sumary == mission.codeMissionSegment
//        })
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "missionCell", for: indexPath) as! MissionCell
//        cell.lblPoints.text = " + \(missionCard?.points ?? "") puntos "
//        cell.lblTitle.text = missionCard?.description
//        cell.lblPointsSoles.text = missionCard?.equivalency
//
//        let status = mission.status
//
//        switch status {
//        case "ACTIVATED":
//
//            cell.lblStatus.text = "Misión pendiente"
//            cell.imgState.image = UIImage(named: "m_p.svg")
//
//        case "INPROCESS":
//            cell.lblStatus.text = "¡Misión en progreso!"
//            cell.imgState.image = UIImage(named: "m_pr.svg")
//
//
//        case "FINALIZED":
//            cell.lblStatus.text = "Procesando tus puntos"
//            cell.imgState.image = UIImage(named: "m_p_p.svg")
//
//        case "BONUS":
//            cell.lblStatus.text = "¡Misión completada!"
//            cell.imgState.image = UIImage(named: "m_c.svg")
//        default:
//            break
//        }
//
//        cell.missionTouchDataIncomplete = { [weak self] in
//            if let content = missionCard {
//                let type = self?.missions[indexPath.row].type
//                switch type {
//                case "ACT":
//                    status == "FINALIZED" || status == "BONUS" ? self?.view.goToMissionRedeemCompleted(mission: mission, missionContent: content) : self?.view.goToDataIncomplete(mission: mission, missionContent: content)
//                case "CUP":
//                    status == "BONUS" ? self?.view.goToMissionRedeemCompleted(mission: mission, missionContent: content) : self?.view.goToMissionRedeem(mission: mission, missionContent: content, steps: self?.dataContentTypeReedem ?? [])
//                case "COM":
//                    status == "BONUS" ? self?.view.goToMissionRedeemCompleted(mission: mission, missionContent: content) : self?.view.goToMissionRedeem(mission: mission, missionContent: content, steps: self?.dataContentTypeBought ?? [])
//                default:
//                    break
//                }
//                atmEtiquetado.logEvent("ui_missions_click_mission", category: "UI :: Missions", action: "Click", label: "card_mission_\(type ?? "no_type")")
//            }
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width: CGFloat = (collectionView.bounds.width - 44 - 10) / 2
//        let height: CGFloat = (width * 13) / 9
//        return CGSize(width: width, height: height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
//    }
//}
