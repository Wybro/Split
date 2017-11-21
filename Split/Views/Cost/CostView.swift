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
    
    enum Metrics {
        static var titleFontSize: CGFloat {
            return smallScreen ? 16 : 18
        }
        static var amountFontSize: CGFloat {
            return smallScreen ? 18 : 20
        }
    }
    
    enum CostType {
        case tip, total, bill
    }
    
    var type: CostType?
    weak var delegate: CostViewDelegate?
    
    var showEach: Bool = false {
        didSet {
            eachLabel.text = showEach ? "each" : ""
            eachLabel.isHidden = !showEach
        }
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont(name: "Barlow-Light", size: Metrics.titleFontSize)
        label.textAlignment = .center
        label.textColor = Constants.gray
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.font = UIFont(name: "Barlow-Medium", size: Metrics.amountFontSize)
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
    
    lazy var eachLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Barlow-light", size: 16)
        label.textColor = Constants.gray
        label.text = ""
        label.textAlignment = .left
        label.isHidden = true
        return label
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
        
        if type == .total {
            titleLabel.font = UIFont(name: "Barlow-Light", size: Metrics.titleFontSize + 2)
            amountLabel.font = UIFont(name: "Barlow-Medium", size: Metrics.amountFontSize + 2)
        }
        
        cardify()
        
        addSubview(titleLabel.usingConstraints())
        addSubview(amountLabel.usingConstraints())
        addSubview(imageView.usingConstraints())
        addSubview(eachLabel.usingConstraints())
        
        amountLabel.center(in: self, type: .horizontal).activate()
        
        NSLayoutConstraint.constraints(
            formats: ["V:|-[title]-[amount(title)]-|",
                      "H:|[title]|",
                      "H:[amount]-[each]",
                      "H:[image(20)]-3-|",
                      "V:|-3-[image(20)]",
                      "V:[each(title)]-|"],
            views: ["title": titleLabel,
                    "amount": amountLabel,
                    "image": imageView,
                    "each": eachLabel]
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
