//
//  SelectCustomViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import UIKit

typealias SelectCustomActionHandler = (_ item: SelectModel?) -> ()

class SelectCustomViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAccept: PrimaryFilledButton!
    @IBOutlet weak var pickerItems: UIPickerView!
    
    var textTitle: String?
    var items = [SelectModel]()
    var actionHandler: SelectCustomActionHandler?
    var selectedItem : SelectModel?
    var rowSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerItems.delegate = self
        self.pickerItems.dataSource = self

        lblTitle.text = textTitle
                
        if let selectedItem = selectedItem {
            rowSelected = items.firstIndex(where: { (item) -> Bool in
                item.id == selectedItem.id
            }) ?? 0
            pickerItems.selectRow(rowSelected, inComponent: 0, animated: true)
        }
        
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
            actionHandler(selectedItem)
        }
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension SelectCustomViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = items[row]
        return item.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = items[row]
        selectedItem = item
    }
}
