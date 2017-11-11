//
//  TipBarView.swift
//  Split
//
//  Created by Connor Wybranowski on 11/9/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

class TipBarView: UIView {
    
    lazy var firstOption: TipButton = .init()
    lazy var secondOption: TipButton = .init()
    lazy var thirdOption: TipButton = .init()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    init(values: [Int]) {
        super.init(frame: .zero)
        setup(values)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(_ values: [Int] = [15,20,25]) {
        firstOption = TipButton(title: values[0])
        secondOption = TipButton(title: values[1])
        thirdOption = TipButton(title: values[2])

        firstOption.color = UIColor(hex: "D52941")
        secondOption.color = UIColor(hex: "F3C969")
        thirdOption.color = UIColor(hex: "2CEAA3")

        let stack = UIStackView(arrangedSubviews: [firstOption, secondOption, thirdOption])
        stack.distribution = .fillEqually
        stack.axis = .horizontal

        addSubview(stack.usingConstraints())

        NSLayoutConstraint.constraints(
            formats: ["H:|[stack]|",
                      "V:|[stack]|"],
            views: ["stack": stack]
        ).activate()
    }
}
