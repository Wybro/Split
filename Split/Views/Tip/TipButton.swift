//
//  TipButton.swift
//  Split
//
//  Created by Connor Wybranowski on 11/9/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

protocol TipButtonDelegate: class {
    func tipButtonPressed(value: Int)
}

class TipButton: UIView {
    
    weak var delegate: TipButtonDelegate?
    lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(TipButton.buttonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    private var backingColor: UIColor = .white
    private var backingValue: Int = 0
    
    var color: UIColor {
        get {
           return backingColor
        } set {
            backingColor = newValue
            button.backgroundColor = newValue
        }
    }
    
    var value: Int {
        get {
            return backingValue
        } set {
            backingValue = newValue
            button.titleLabel?.text = "\(newValue)%"
        }
    }
    
    init(title: Int = 0) {
        super.init(frame: .zero)
        setup(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(_ title: Int) {
        value = title
        
//        button.layer.cornerRadius = button.frame.width/2
//        button.clipsToBounds = true
        
        addSubview(button.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["V:|[button]|",
                      "H:|[button]|"],
            views: ["button": button]
        ).activate()
    }
    
    @objc func buttonTapped(sender: UIButton) {
        delegate?.tipButtonPressed(value: value)
        print("value: \(value)")
    }
}
