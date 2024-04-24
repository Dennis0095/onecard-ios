//
//  SelectDateViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import UIKit

typealias SelectDateActionHandler = (_ item: Date?) -> ()

class SelectDateViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAccept: PrimaryFilledButton!
    @IBOutlet weak var pickerItems: UIDatePicker!
    
    var textTitle: String?
    var actionHandler: SelectDateActionHandler?
    var selectedItem : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = textTitle
        
        pickerItems.locale = Locale(identifier: "es_PE")
        pickerItems.date = selectedItem ?? Date()
        pickerItems.maximumDate = Date()

        btnAccept.configure(text: Constants.accept, status: .enabled)
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        if let actionHandler = self.actionHandler {
            actionHandler(nil)
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickAccept(_ sender: Any) {
        if let actionHandler = self.actionHandler {
            actionHandler(pickerItems.date)
        }
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
