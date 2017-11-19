//
//  EntryView.swift
//  Split
//
//  Created by Connor Wybranowski on 11/18/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

protocol EntryViewDelegate: class {
    func costDidChange(value: Double)
}

class EntryView: UIView {
    
    weak var delegate: EntryViewDelegate?
    
    lazy var keypad: KeypadView = .init()
    
    lazy var costLabel: UILabel = {
        let label = UILabel()
        label.text = "$0"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        keypad.delegate = self
        
        addSubview(keypad.usingConstraints())
        addSubview(costLabel.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["H:|[cost]|",
                      "H:|[keypad]|",
                      "V:|[cost]-[keypad(>=300)]|"],
            views: ["keypad": keypad,
                    "cost": costLabel]
        ).activate()
    }
}

extension EntryView: KeypadDelegate {
    func keypadPressed(tap: Tap) {
        let current = costLabel.text ?? ""
        
        if tap.action == .delete {
            if current != "$0" {
                let newStr = String(current.dropLast())
                let val = newStr == "$" ? "$0" : newStr
                costLabel.text = val
                
                let costVal = Double(val.replacingOccurrences(of: "$", with: "")) ?? 0.00
                delegate?.costDidChange(value: costVal)
            }
        } else if tap.action == .append {
            let val = current == "$0" ? "$\(tap.data)" : current + tap.data
            costLabel.text = val
            
            let costVal = Double(val.replacingOccurrences(of: "$", with: "")) ?? 0.00
            delegate?.costDidChange(value: costVal)
        } else if tap.action == .decimal {
            if !current.contains(".") {
                let val = current == "$0" ? "$0." : current + "."
                costLabel.text = val
                
                let costVal = Double(val.replacingOccurrences(of: "$", with: "")) ?? 0.00
                delegate?.costDidChange(value: costVal)
            }
        }
    }
}
