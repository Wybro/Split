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
        let tap = UITapGestureRecognizer(target: self, action: #selector(ResultsBarView.animateView))
        addGestureRecognizer(tap)
        
        let stack = UIStackView(arrangedSubviews: [tip, total, bill])
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 8
        
        addSubview(stack.usingConstraints())
        addSubview(peopleLabel.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["H:|-10-[stack]-10-|",
                      "H:|[label]|",
                      "V:|[stack]-[label]|"],
            views: ["stack": stack,
                    "label": peopleLabel]
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
        
//        viewType = viewType == .full ? .partial : .full
//
//        UIView.animate(withDuration: 0.25, animations: {
//
//            let xShift: CGFloat = self.viewType == .full ? -20 : 20
//
//            self.tip.transform = CGAffineTransform(translationX: xShift, y: 0)
//            self.tip.alpha = self.viewType == .full ? 1 : 0
//
//            self.bill.transform = CGAffineTransform(translationX: -xShift, y: 0)
//            self.bill.alpha = self.viewType == .full ? 1 : 0
//        }) { (done) in
//            self.animating = false
//        }
    }
    
    func hideLabel(_ value: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.peopleLabel.alpha = value ? 0 : 1
        }
    }
}
