//
//  ResultsBarView.swift
//  Split
//
//  Created by Connor Wybranowski on 11/9/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

class ResultsBarView: UIView {
    
    enum Metrics {
        static var resultHeight: CGFloat {
            return currentDevice == .iPhone5 ? 60 : (smallScreen ? 75 : 85)
        }
        
        static var tipViewHeight: CGFloat = Metrics.resultHeight * 0.5
    }
    
    private var animating = false
    
    lazy var tip: CostView = .init(type: .tip)
    lazy var total: CostView = .init(type: .total)
    lazy var bill: CostView = .init(type: .bill)
    lazy var tipView: TipView = .init()

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        tip.delegate = self
        total.delegate = self
        bill.delegate = self
        
        addSubview(tip.usingConstraints())
        addSubview(total.usingConstraints())
        addSubview(bill.usingConstraints())
        addSubview(tipView.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["H:|-10-[total]-10-|",
                      "H:|-10-[tip]-[bill(tip)]-10-|",
                      "H:|-10-[tipView]-10-|",
                      "V:|[total(rHeight)]-[tip(total)]-[tipView(tHeight)]-|",
                      "V:[total]-[bill(total)]"],
            metrics: ["rHeight": Metrics.resultHeight,
                      "tHeight": Metrics.tipViewHeight],
            views: ["tip": tip,
                    "total": total,
                    "bill": bill,
                    "tipView": tipView]
        ).activate()
    }
    
    func update(cost: Double, tipNum: Double, numPeople: Int = 1) {
        let tipVal = (cost * tipNum) / Double(numPeople)
        let billVal = cost / Double(numPeople)
        let totalVal = tipVal + billVal
        
        tip.update(cost: tipVal)
        bill.update(cost: billVal)
        total.update(cost: totalVal)
        
        total.showEach = numPeople > 1
    }
}

extension ResultsBarView: CostViewDelegate {
    func didTapCostView(sender: CostView) {
        if sender.type == .tip {
            sender.shake(.light)
            tipView.toggle()
        }
    }
}
