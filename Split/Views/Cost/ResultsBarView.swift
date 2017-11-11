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
        label.textAlignment = .center
        label.text = "per person"
        label.isHidden = true
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
        if viewType == .full {
            viewType = .partial
            
            UIView.animate(withDuration: 0.25, animations: {
                self.tip.transform = CGAffineTransform(translationX: 20, y: 0)
                self.tip.alpha = 0
                
                self.bill.transform = CGAffineTransform(translationX: -20, y: 0)
                self.bill.alpha = 0
            }, completion: { (done) in
                self.animating = false
            })
        } else {
            viewType = .full
            
            UIView.animate(withDuration: 0.25, animations: {
                self.tip.transform = CGAffineTransform(translationX: -20, y: 0)
                self.tip.alpha = 1
                
                self.bill.transform = CGAffineTransform(translationX: 20, y: 0)
                self.bill.alpha = 1
            }, completion: { (done) in
                self.animating = false
            })
        }
    }
    
    func hideLabel(_ value: Bool) {
        peopleLabel.isHidden = value
    }
}
