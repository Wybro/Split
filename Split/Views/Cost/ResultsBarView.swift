//
//  ResultsBarView.swift
//  Split
//
//  Created by Connor Wybranowski on 11/9/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

class ResultsBarView: UIView {
    
    private enum ViewTypes {
        case full, partial
    }
    
    private var viewType = ViewTypes.full
    private var animating = false
    
    lazy var tip: CostView = .init(type: .tip)
    lazy var total: CostView = .init(type: .total)
    lazy var bill: CostView = .init(type: .bill)
    lazy var tipBar: TipView = .init()
    
    lazy var peopleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "per person"
        label.alpha = 0
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
        tip.delegate = self
        total.delegate = self
        bill.delegate = self
        
        addSubview(tip.usingConstraints())
        addSubview(total.usingConstraints())
        addSubview(bill.usingConstraints())
        addSubview(tipBar.usingConstraints())
        addSubview(peopleLabel.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["H:|-10-[total]-10-|",
                      "H:|-10-[tip]-[bill(tip)]-10-|",
                      "H:|-10-[tipBar]-10-|",
                      "H:|[label]|",
                      "V:|[total]-[tip]-[tipBar(tip)]-[label]|",
                      "V:|[total]-[bill(tip)]|"],
            views: ["tip": tip,
                    "total": total,
                    "bill": bill,
                    "label": peopleLabel,
                    "tipBar": tipBar]
            ).activate()
    }
    
    func update(cost: Double, tipNum: Double, numPeople: Int = 1) {
        let tipVal = (cost * tipNum) / Double(numPeople)
        let billVal = cost / Double(numPeople)
        let totalVal = tipVal + billVal
        
        tip.update(cost: tipVal)
        bill.update(cost: billVal)
        total.update(cost: totalVal)
    }
    
    @objc func animateView() {
        animating = true
        viewType = viewType == .full ? .partial : .full
        if viewType == .full {
            UIView.animate(withDuration: 0.25, animations: {
                self.tip.transform = .identity
                self.tip.alpha = 1
                self.bill.transform = .identity
                self.bill.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                let xShift: CGFloat = 20
                self.tip.transform = CGAffineTransform(translationX: xShift, y: 0)
                self.tip.alpha = 0
                self.bill.transform = CGAffineTransform(translationX: -xShift, y: 0)
                self.bill.alpha = 0
               
            })
        self.animating = false
        }
    }
    
    func hideLabel(_ value: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.peopleLabel.alpha = value ? 0 : 1
        }
    }
}

extension ResultsBarView: CostViewDelegate {
    func didTapCostView(sender: CostView) {
        if sender.type == .tip {
            sender.shake(.light)
            tipBar.toggle()
        }
    }
}
