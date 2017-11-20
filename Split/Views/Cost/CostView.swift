//
//  CostView.swift
//  Split
//
//  Created by Connor Wybranowski on 11/9/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

protocol CostViewDelegate: class {
    func didTapCostView(sender: CostView)
}

class CostView: UIView {
    
    enum CostType {
        case tip, total, bill
    }
    
    var type: CostType?
    weak var delegate: CostViewDelegate?

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont(name: "Barlow-Light", size: 16)
        label.textAlignment = .center
        label.textColor = Constants.gray
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.font = UIFont(name: "Barlow-Medium", size: 20)
        label.textAlignment = .center
        label.textColor = Constants.gray
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "info")
        imageView.isHidden = true
        return imageView
    }()
    
    init(type: CostType) {
        super.init(frame: .zero)
        setup(type: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(type: CostType) {
        self.type = type
        imageView.isHidden = !(type == .tip)
        
        addTap()
        
        let label = type == .tip ? "Tip" : (type == .total ? "Total" : "Bill")
        titleLabel.text = label
        titleLabel.textColor = Constants.gray
        
        let titleSize: CGFloat = type == .total ? 20 : 16
        titleLabel.font = UIFont(name: "Barlow", size: titleSize)
        
        let amountSize: CGFloat = type == .total ? 24 : 20
        amountLabel.font = UIFont(name: "Barlow", size: amountSize)
        
        cardify()
        
        addSubview(titleLabel.usingConstraints())
        addSubview(amountLabel.usingConstraints())
        addSubview(imageView.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["V:|-[title(>=25)]-[amount(>=30)]-|",
                      "H:|[title]|",
                      "H:|[amount]|",
                      "H:[image(20)]-3-|",
                      "V:|-3-[image(20)]"],
            views: ["title": titleLabel,
                    "amount": amountLabel,
                    "image": imageView]
        ).activate()
    }
    
    func addTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(CostView.didTapView(sender:)))
        addGestureRecognizer(tap)
    }
    
    func update(cost: Double) {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        amountLabel.text = "\(formatter.string(from: NSNumber(value: cost)) ?? "$0.00")"
    }
    
    @objc func didTapView(sender: CostView) {
        delegate?.didTapCostView(sender: self)
    }
}
