//
//  RowView.swift
//  Split
//
//  Created by Connor Wybranowski on 11/10/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

protocol RowViewDelegate: class {
    func rowButtonPressed(value: String)
}

class RowView: UIView {
    weak var delegate: RowViewDelegate?
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(RowView.pressedButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var centerButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(RowView.pressedButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(RowView.pressedButton(sender:)), for: .touchUpInside)
        return button
    }()

    init(left: String, center: String, right: String) {
        super.init(frame: .zero)
        setup(left: left, center: center, right: right)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(left: String, center: String, right: String) {
        leftButton.setTitle(left, for: .normal)
        centerButton.setTitle(center, for: .normal)
        rightButton.setTitle(right, for: .normal)
        
        let stack = UIStackView(arrangedSubviews: [leftButton, centerButton, rightButton])
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        addSubview(stack.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["H:|[stack]|",
                      "V:|[stack]|"],
            views: ["stack": stack]
        ).activate()
    }
    
    @objc func pressedButton(sender: UIButton) {
        delegate?.rowButtonPressed(value: sender.currentTitle ?? "")
    }
}
