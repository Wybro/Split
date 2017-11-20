//
//  TipView.swift
//  Split
//
//  Created by Connor Wybranowski on 11/19/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

protocol TipViewDelegate: class {
    func tipDidChange(value: Double)
}

class TipView: UIView {
    
    var enabled = false
    
    weak var delegate: TipViewDelegate?
    
    lazy var tipBar: UISegmentedControl = {
        let control = UISegmentedControl(items: ["15%", "20%", "25%"])
        control.selectedSegmentIndex = 1
        control.tintColor = Constants.green
        control.addTarget(self, action: #selector(TipView.selectedSegmentDidChange(sender:)), for: .valueChanged)
        let attr = NSDictionary(object: UIFont(name: "Barlow", size: 16.0)!, forKey: NSAttributedStringKey.font as NSCopying)
        control.setTitleTextAttributes(attr as [NSObject : AnyObject], for: .normal)
        return control
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    func setup() {
        isHidden = true
        cardify()
        addSubview(tipBar.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["H:|-[tipBar]-|",
                      "V:|-[tipBar]-|"],
            views: ["tipBar": tipBar]
        ).activate()
    }
    
    @objc func selectedSegmentDidChange(sender: UISegmentedControl) {
        let tipStr = (sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "20%")
        let cleanStr = tipStr.replacingOccurrences(of: "%", with: "")
        let tipVal = (Double(cleanStr) ?? 20.0) / 100.0
//        tipValue = tipVal
        delegate?.tipDidChange(value: tipVal)
    }
    
    func toggle() {
        if enabled {
            enabled = false
            
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(translationX: 0, y: -20)
            }, completion: { (complete) in
                self.isHidden = true
            })
        } else {
            enabled = true
            isHidden = false
            
            transform = CGAffineTransform(translationX: 0, y: -20)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1
                self.transform = .identity
            })
        }
    }
}
