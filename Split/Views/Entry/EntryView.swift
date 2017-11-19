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
    
    enum Metrics {
        static let keypadHeight = UIScreen.main.bounds.height * 0.33
    }
    
    weak var delegate: EntryViewDelegate?
    
    lazy var keypad: KeypadView = .init()
    
    lazy var header: HeaderView = .init()
    
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
        addSubview(header.usingConstraints())
        
        header.center(in: self, type: .horizontal).activate()
        
        NSLayoutConstraint.constraints(
            formats: ["H:|[keypad]|",
                      "V:|[entry]-[keypad(kpHeight)]|"],
            metrics: ["kpHeight": Metrics.keypadHeight],
            views: ["keypad": keypad,
                    "entry": header]
        ).activate()
    }
}

extension EntryView: KeypadDelegate {
    
    func keypadPressed(tap: Tap) {
        switch tap.action {
        case .append:
            if header.decimalMode {
                header.userDecimals[header.userDecimal] = tap.data
                header.userDecimal += 1
            } else {
                header.append(tap.data, type: .primary)
            }
            delegate?.costDidChange(value: header.doubleValue)
        case .delete:
            if header.decimalMode {
                if header.userDecimal - 1 < header.userDecimals.count {
                    header.userDecimals[header.userDecimal - 1] = "0"
                    header.userDecimal -= 1
                }
                if header.userDecimal == 0 {
                    header.decimalMode = false
                }
            } else {
                header.dropLast()
            }
            delegate?.costDidChange(value: header.doubleValue)
        case .decimal:
            header.decimalMode = true
        }
        
        if header.full {
            keypad.enabled(.max)
        } else if header.empty {
            keypad.enabled(.initial)
        } else {
            header.decimalMode ? keypad.enabled(.decimal) : keypad.enabled(.nondecimal)
        }
    }
}

extension UIView {
    enum FillType {
        case vertical, horizontal, full
    }
    func fill(_ superview: UIView, type: FillType = .full) -> [NSLayoutConstraint] {
        
        var attributes: [NSLayoutAttribute] = []
        
        switch type {
        case .full: attributes = [.top, .bottom, .left, .right]
        case .horizontal: attributes = [.left, .right]
        case .vertical: attributes = [.top, .bottom]
        }
        
        return attributes.map {
            NSLayoutConstraint(item: self, attribute: $0, relatedBy: .equal, toItem: superview, attribute: $0, multiplier: 1, constant: 0)
        }
    }
}
