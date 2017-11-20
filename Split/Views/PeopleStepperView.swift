//
//  PeopleStepper.swift
//  Split
//
//  Created by Kyle Wybranowski on 11/18/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import Foundation
import UIKit

protocol PeopleStepperDelegate: class {
    func stepperDidChange(value: Int)
}

class PeopleStepperView: UIView {
    
    private var backingCount: Int = 1
    
    var count: Int {
        get {
            return backingCount
        } set {
            backingCount = newValue
            countLabel.text = "\(newValue)"
            
            let peopleStr = newValue == 1 ? "Person" : "People"
            extraLabel.text = peopleStr
        }
    }
    
    weak var delegate: PeopleStepperDelegate?
    
    lazy var plus: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(PeopleStepperView.didTouchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(PeopleStepperView.didTouchUp(sender:)), for: [.touchUpInside,.touchDragOutside])
        button.addTarget(self, action: #selector(PeopleStepperView.didTap(sender:)), for: .touchUpInside)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont(name: "Barlow-Bold", size: 30)
        button.layer.cornerRadius = 10
        button.backgroundColor = Constants.white
        button.setTitleColor(Constants.green, for: .normal)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 0, height: 1)
        return button
    }()
    
    lazy var minus: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(PeopleStepperView.didTouchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(PeopleStepperView.didTouchUp(sender:)), for: [.touchUpInside,.touchDragOutside])
        button.addTarget(self, action: #selector(PeopleStepperView.didTap(sender:)), for: .touchUpInside)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont(name: "Barlow-Bold", size: 30)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.layer.cornerRadius = 10
        button.backgroundColor = Constants.white
        button.setTitleColor(Constants.green, for: .normal)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 0, height: 1)
        return button
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Barlow-Bold", size: 24)
        label.textColor = Constants.white
        label.text = "\(count)"
        label.textAlignment = .center
        return label
    }()
    
    lazy var extraLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Barlow", size: 16)
        label.textColor = Constants.white
        label.text = "Person"
        label.textAlignment = .center
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
        addSubview(plus.usingConstraints())
        addSubview(minus.usingConstraints())
        addSubview(countLabel.usingConstraints())
        addSubview(extraLabel.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["H:|[minus(40)]-[count(30)]-[plus(minus)]|",
                      "H:|[extra]|",
                      "V:|[count(40)][extra]|",
                      "V:|[minus(40)][extra]|",
                      "V:|[plus(40)][extra]|"],
            views: ["plus": plus,
                    "minus": minus,
                    "count": countLabel,
                    "extra": extraLabel]
        ).activate()
    }
    
    @objc func didTouchDown(sender: UIButton) {
        UIView.animate(withDuration: 0.05) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    @objc func didTouchUp(sender: UIButton) {
        UIView.animate(withDuration: 0.05) {
            sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    @objc func didTap(sender: UIButton) {
        if sender.titleLabel?.text == "+" && count < 10 {
            count += 1
            delegate?.stepperDidChange(value: count)
        } else if sender.titleLabel?.text == "-" && count > 1 {
            count -= 1
            delegate?.stepperDidChange(value: count)
        }
    }
}
