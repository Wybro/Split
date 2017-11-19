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
        button.titleLabel?.font = UIFont(name: "Barlow-Bold", size: 20)
        button.setTitleColor(Constants.white, for: .normal)
        button.addTarget(self, action: #selector(RowView.pressedButton(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(RowView.didTouchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(RowView.didTouchUp(sender:)), for: [.touchUpInside, .touchDragOutside])
        button.tag = 0
        return button
    }()
    
    lazy var centerButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Barlow-Bold", size: 20)
        button.setTitleColor(Constants.white, for: .normal)
        button.addTarget(self, action: #selector(RowView.pressedButton(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(RowView.didTouchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(RowView.didTouchUp(sender:)), for: [.touchUpInside, .touchDragOutside])
        button.tag = 1
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Barlow-Bold", size: 20)
        button.setTitleColor(Constants.white, for: .normal)
        button.addTarget(self, action: #selector(RowView.pressedButton(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(RowView.didTouchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(RowView.didTouchUp(sender:)), for: [.touchUpInside, .touchDragOutside])
        button.tag = 2
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
    
    func enabled(l: Bool = true, m: Bool = true, r: Bool = true) {
        leftButton.alpha = l ? 1 : 0.6
        leftButton.isUserInteractionEnabled = l
        
        centerButton.alpha = m ? 1 : 0.6
        centerButton.isUserInteractionEnabled = m
        
        rightButton.alpha = r ? 1 : 0.6
        rightButton.isUserInteractionEnabled = r
    }
}

// MARK: - Animation
extension RowView {
    @objc func didTouchDown(sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
    }
    
    @objc func didTouchUp(sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
    }
}
