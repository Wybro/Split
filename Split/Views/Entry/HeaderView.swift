//
//  HeaderView.swift
//  Split
//
//  Created by Connor Wybranowski on 11/19/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    enum Metrics {
        static var pTextSize: CGFloat {
            return smallScreen ? 30 : 35
        }
        
        static var dTextSize: CGFloat {
            return smallScreen ? 18 : 23
        }
        
        static var cTextSize: CGFloat {
            return smallScreen ? 16 : 20
        }
    }
    
    var userDecimals: [String] = ["0", "0"] {
        didSet {
            decimal.text = userDecimals.reduce("",+)
            shake()
        }
    }
    
    var userPrimaries: [String] = ["0"] {
        didSet {
            primary.text = userPrimaries.reduce("",+)
            shake()
        }
    }
    
    var decimalMode: Bool = false {
        didSet {
            decimal.alpha = decimalMode ? 0.6 : 0
        }
    }
    
    var empty: Bool {
        return userPrimary == 0 && userDecimal == 0
    }
    
    var userDecimal = 0 {
        didSet {
            let alpha: CGFloat = userDecimal > 0 ? 1 : 0.6
            decimal.alpha = alpha
        }
    }
    var userPrimary = 0
    
    var doubleValue: Double {
        let primary = userPrimaries.reduce("", +)
        let decimal = userDecimals.reduce("", +)
        return Double("\(primary).\(decimal)") ?? 0.00
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
        label.font = UIFont(name: "Barlow-Bold", size: Metrics.cTextSize)
        label.textColor = Constants.white
        return label
    }()
    
    lazy var primary: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right
        label.font = UIFont(name: "Barlow-Bold", size: Metrics.pTextSize)
        label.textColor = Constants.white
        return label
    }()
    
    lazy var decimal: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .left
        label.font = UIFont(name: "Barlow-Bold", size: Metrics.dTextSize)
        label.textColor = Constants.white
        label.alpha = 0
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
                      "V:|[decimal]|",
                      "V:|[cash]|"],
            views: ["primary": primary,
                    "decimal": decimal,
                    "cash": cash]
        ).activate()
    }
}

// MARK: - Append
extension HeaderView {
    enum ActionType {
        case primary, decimal
    }
    
    func append(_ element: String, type: ActionType) {
        switch type {
        case .primary: appendPrimary(element)
        case .decimal: appendDecimal(element)
        }
    }
    
    private func appendPrimary(_ element: String) {
        guard userPrimary < 5 else { return }
        if userPrimaries.first == "0" {
            if element != "0" {
                userPrimaries[0] = element
                userPrimary += 1
            }
        } else {
            userPrimaries.append(element)
            userPrimary += 1
        }
    }
    
    private func appendDecimal(_ element: String) {
        guard userDecimal < 2 else { return }
        userDecimals[userDecimal] = element
        userDecimal += 1
    }
}

// MARK: - Delete
extension HeaderView {
    func delete(type: ActionType) {
        switch type {
        case .primary: deletePrimary()
        case .decimal: deleteDecimal()
        }
    }
    
    private func deletePrimary() {
        if userPrimaries.first != "0" && !userPrimaries.isEmpty {
            userPrimaries.removeLast()
            userPrimary -= 1
            if userPrimary == 0 {
                userPrimaries.append("0")
            }
        }
    }
    
    private func deleteDecimal() {
        guard decimalMode else { return }
        
        if userDecimals == ["0", "0"] && userDecimal == 0 {
            decimalMode = false
        } else if userDecimal - 1 < userDecimals.count {
            userDecimals[userDecimal - 1] = "0"
            userDecimal -= 1
        }
        if userDecimal == 0 {
            decimalMode = false
        }
    }
}
