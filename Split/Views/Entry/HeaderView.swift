//
//  HeaderView.swift
//  Split
//
//  Created by Connor Wybranowski on 11/19/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    private var backingPrimaryStr = "0"
    private var backingDecimalStr = ""
    
    var primaryStr: String {
        get {
            return backingPrimaryStr
        } set {
            backingPrimaryStr = newValue
            primary.text = newValue
        }
    }
    
    var decimalStr: String {
        get {
            return backingDecimalStr
        } set {
            backingDecimalStr = newValue
            decimal.text = newValue
        }
    }
    
    private var backingUserD: [String] = ["0","0"]
    private var backingUserP: [String] = ["0"]
    
    var userDecimals: [String] {
        get {
            return backingUserD
        } set {
            backingUserD = newValue
            decimal.text = newValue.reduce("",+)
            shake()
        }
    }
    
    var userPrimaries: [String] {
        get {
            return backingUserP
        } set {
            backingUserP = newValue
            primary.text = newValue.reduce("",+)
            shake()
        }
    }
    
    var decimalMode: Bool = false {
        didSet {
            decimal.alpha = decimalMode ? 1 : 0.6
        }
    }
    
    var empty: Bool {
        return userPrimary == 0 && userDecimal == 0
    }
    
    var userDecimal = 0
    var userPrimary = 0
    
    var doubleValue: Double {
        let primary = userPrimaries.reduce("", +)
        let decimal = userDecimals.reduce("", +)
        return Double("\(primary).\(decimal)") ?? 0.00
    }
    
    var primaryFull: Bool {
        return userPrimary == 5
    }
    
    var decimalFull: Bool {
        return userDecimal == 2
    }
    
    var full: Bool {
        return decimalFull
    }
    
    lazy var cash: UILabel = {
        let label = UILabel()
        label.text = "$"
        label.textAlignment = .right
        label.font = UIFont(name: "Barlow-Bold", size: 20)
        label.textColor = Constants.white
        return label
    }()
    
    lazy var primary: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right
        label.font = UIFont(name: "Barlow-Bold", size: 35)
        label.textColor = Constants.white
        return label
    }()
    
    lazy var decimal: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .left
        label.font = UIFont(name: "Barlow-Bold", size: 25)
        label.textColor = Constants.white
        label.alpha = 0.6
        return label
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }

    func setup() {
        addSubview(cash.usingConstraints())
        addSubview(primary.usingConstraints())
        addSubview(decimal.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["H:|[cash]-2-[primary]-2-[decimal]|",
                      "V:|[primary]|",
                      "V:|-2-[decimal]",
                      "V:|-4-[cash]"],
            views: ["primary": primary,
                    "decimal": decimal,
                    "cash": cash]
        ).activate()
    }
    
    enum AppendType {
        case primary, decimal
    }
    
    func append(_ element: String, type: AppendType) {
        switch type {
        case .primary:
            if userPrimary < 5 {
                if userPrimaries.first == "0"{
                    if element != "0" {
                        userPrimaries[0] = element
                        userPrimary += 1
                    }
                } else {
                    userPrimaries.append(element)
                    userPrimary += 1
                }
            }
        case .decimal: userDecimals.append(element) 
        }
    }
    
    func dropLast() {
        if userPrimaries.first != "0" && !userPrimaries.isEmpty {
            userPrimaries.removeLast()
            userPrimary -= 1
            if userPrimary == 0 {
                userPrimaries.append("0")
            }
        }
    }
}


// MARK: - Animations
extension HeaderView {
    func shake() {
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
}
