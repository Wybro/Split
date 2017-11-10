//
//  ResultsBarView.swift
//  Split
//
//  Created by Connor Wybranowski on 11/9/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

class ResultsBarView: UIView {
    
    lazy var tip: CostView = .init(type: .tip)
    lazy var total: CostView = .init(type: .total)
    lazy var bill: CostView = .init(type: .bill)

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        let stack = UIStackView(arrangedSubviews: [tip, total, bill])
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        addSubview(stack.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["H:|-10-[stack]-10-|",
                      "V:|[stack]|"],
            views: ["stack": stack]
        ).activate()
    }
}
