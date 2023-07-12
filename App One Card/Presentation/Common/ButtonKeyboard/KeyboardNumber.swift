//
//  KeyboardNumber.swift
//  App One Card
//
//  Created by Paolo Arambulo on 22/06/23.
//

typealias ButtonActionHandler = ((String) -> Void)

import UIKit

class KeyboardNumber: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    @IBOutlet weak var btnFive: UIButton!
    @IBOutlet weak var btnSix: UIButton!
    @IBOutlet weak var btnSeven: UIButton!
    @IBOutlet weak var btnEight: UIButton!
    @IBOutlet weak var btnNine: UIButton!
    @IBOutlet weak var btnZero: UIButton!
    
    var actionButton: ButtonActionHandler?
    var actionClear: VoidActionHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("KeyboardNumber", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        [btnZero, btnOne, btnTwo, btnThree, btnFour, btnFive, btnSix, btnSeven, btnEight, btnNine].forEach { button in
            button?.layer.cornerRadius = 32
        }
    }
    
    @IBAction func one(_ sender: Any) {
        if let action = actionButton {
            action("1")
        }
    }
    
    @IBAction func two(_ sender: Any) {
        if let action = actionButton {
            action("2")
        }
    }
    
    @IBAction func three(_ sender: Any) {
        if let action = actionButton {
            action("3")
        }
    }
    
    @IBAction func four(_ sender: Any) {
        if let action = actionButton {
            action("4")
        }
    }
    
    @IBAction func five(_ sender: Any) {
        if let action = actionButton {
            action("5")
        }
    }
    
    @IBAction func six(_ sender: Any) {
        if let action = actionButton {
            action("6")
        }
    }
    
    @IBAction func seven(_ sender: Any) {
        if let action = actionButton {
            action("7")
        }
    }
    
    @IBAction func eight(_ sender: Any) {
        if let action = actionButton {
            action("8")
        }
    }
    
    @IBAction func nine(_ sender: Any) {
        if let action = actionButton {
            action("9")
        }
    }
    
    @IBAction func zero(_ sender: Any) {
        if let action = actionButton {
            action("0")
        }
    }
    
    @IBAction func deleteBack(_ sender: Any) {
        if let action = actionClear {
            action()
        }
    }
}
