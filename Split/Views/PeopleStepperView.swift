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
    func didToggleStepper()
}

class PeopleStepperView: UIView {
    
    var countEngaged: Bool = false
    
    private var backingCount: Int = 1
    
    var count: Int {
        get {
            return backingCount
        } set {
            backingCount = newValue
//            countLabelButton.set = "\(newValue)"
            countLabelButton.setTitle("\(newValue)", for: .normal)

            
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
        button.setTitleColor(Constants.green, for: .normal)
        button.cardify()
        button.isHidden = true
        return button
    }()
    
    lazy var minus: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(PeopleStepperView.didTouchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(PeopleStepperView.didTouchUp(sender:)), for: [.touchUpInside,.touchDragOutside])
        button.addTarget(self, action: #selector(PeopleStepperView.didTap(sender:)), for: .touchUpInside)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont(name: "Barlow-Bold", size: 30)
        button.setTitleColor(Constants.green, for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.cardify()
        button.isHidden = true
        return button
    }()
    
//    lazy var countLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Barlow-Bold", size: 24)
//        label.textColor = Constants.white
//        label.text = "\(count)"
//        label.textAlignment = .center
//        label.cardify()
//        return label
//    }()
    
    lazy var countLabelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(PeopleStepperView.didTouchCountLabel(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(PeopleStepperView.didTouchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(PeopleStepperView.didTouchUp(sender:)), for: [.touchUpInside,.touchDragOutside])
        button.titleLabel?.font = UIFont(name: "Barlow-Bold", size: 30)
        button.setTitleColor(Constants.green, for: .normal)
        button.setTitle("\(count)", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.cardify()
        return button
    }()
    
    lazy var extraLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Barlow-Medium", size: 16)
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
        addSubview(countLabelButton.usingConstraints())
        addSubview(extraLabel.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["H:|[minus(40)]-[count(35)]-[plus(minus)]|",
                      "H:|[extra]|",
                      "V:|[count(40)][extra]|",
                      "V:|[minus(40)][extra]|",
                      "V:|[plus(40)][extra]|"],
            views: ["plus": plus,
                    "minus": minus,
                    "count": countLabelButton,
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
            sender.transform = .identity
        }
    }
    
    func toggle() {
        delegate?.didToggleStepper()
        if !countEngaged {
            plus.isHidden = false
            minus.isHidden = false
            plus.alpha = 0
            minus.alpha = 0
            plus.transform = CGAffineTransform(translationX: -20, y: 0)
            minus.transform = CGAffineTransform(translationX: 20, y: 0)
            UIView.animate(withDuration: 0.1) {
                self.plus.alpha = 1
                self.minus.alpha = 1
                self.plus.transform = .identity
                self.minus.transform = .identity
            }
            countEngaged = true
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                self.plus.alpha = 0
                self.minus.alpha = 0
                self.plus.transform = CGAffineTransform(translationX: -20, y: 0)
                self.minus.transform = CGAffineTransform(translationX: 20, y: 0)
            }, completion: { (complete) in
                self.plus.isHidden = true
                self.minus.isHidden = true
            })
            countEngaged = false
        }
    }
    
    @objc func didTouchCountLabel(sender: UIButton) {
        toggle()
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
