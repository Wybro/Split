//
//  KeypadView.swift
//  Split
//
//  Created by Connor Wybranowski on 11/10/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

protocol KeypadDelegate: class {
    func keypadPressed(value: String)
}

class KeypadView: UIView {
    weak var delegate: KeypadDelegate?
    
    lazy var firstRow: RowView = .init(left: "1", center: "2", right: "3")
    lazy var secondRow: RowView = .init(left: "4", center: "5", right: "6")
    lazy var thirdRow: RowView = .init(left: "7", center: "8", right: "9")
    lazy var fourthRow: RowView = .init(left: ".", center: "0", right: "<")

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        backgroundColor = .red
        
        firstRow.delegate = self
        secondRow.delegate = self
        thirdRow.delegate = self
        fourthRow.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [firstRow, secondRow, thirdRow, fourthRow])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        
        addSubview(stack.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["H:|[stack]|",
                      "V:|[stack]|"],
            views: ["stack": stack]
        ).activate()
    }
}

extension KeypadView: RowViewDelegate {
    func rowButtonPressed(sender: String) {
        delegate?.keypadPressed(value: sender)
    }
}
