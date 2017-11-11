//
//  CostView.swift
//  Split
//
//  Created by Connor Wybranowski on 11/9/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

class CostView: UIView {
    
    enum CostType {
        case tip, total, bill
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont(name: "Barlow-Light", size: 16)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.font = UIFont(name: "Barlow-Medium", size: 20)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    init(type: CostType) {
        super.init(frame: .zero)
        setup(type: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(type: CostType) {
        let label = type == .tip ? "Tip" : (type == .total ? "Total" : "Bill")
        titleLabel.text = label
        
        let titleSize: CGFloat = type == .total ? 20 : 16
        titleLabel.font = UIFont(name: "Barlow", size: titleSize)
        
        let amountSize: CGFloat = type == .total ? 24 : 20
        amountLabel.font = UIFont(name: "Barlow", size: amountSize)
        
        addSubview(titleLabel.usingConstraints())
        addSubview(amountLabel.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["V:|[title(>=25)]-[amount(>=30)]|",
                      "H:|[title]|",
                      "H:|[amount]|"],
            views: ["title": titleLabel,
                    "amount": amountLabel]
        ).activate()
    }
    
    func update(cost: Double) {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        amountLabel.text = "\(formatter.string(from: NSNumber(value: cost)) ?? "$0.00")"
    }
}
