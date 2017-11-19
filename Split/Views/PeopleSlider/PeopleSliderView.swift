//
//  PeopleSliderView.swift
//  Split
//
//  Created by Connor Wybranowski on 11/9/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

protocol PeopleSliderDelegate: class {
    func sliderValueDidChange(value: Int)
}

class PeopleSliderView: UIView {
    
    weak var delegate: PeopleSliderDelegate?

    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.isContinuous = true
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.addTarget(self, action: #selector(PeopleSliderView.sliderValueDidChange(sender:)), for: .valueChanged)
        return slider
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = Constants.gray
        label.text = "1"
        label.textAlignment = .center
        return label
    }()
    
    lazy var extraLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = Constants.gray
        label.text = "Person"
        label.textAlignment = .center
        return label
    }()
    
    private var backingValue: Int = 1
    private var backingColor: UIColor = .blue
    
    var value: Int {
        get {
           return backingValue
        } set {
            backingValue = newValue
            countLabel.text = "\(newValue)"
            
            let peopleStr = newValue == 1 ? "Person" : "People"
            extraLabel.text = peopleStr
        }
    }
    
    var sliderColor: UIColor {
        get {
            return backingColor
        } set {
            backingColor = newValue
            slider.tintColor = newValue
            slider.thumbTintColor = newValue
        }
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        addSubview(slider.usingConstraints())
        addSubview(countLabel.usingConstraints())
        addSubview(extraLabel.usingConstraints())
        
        NSLayoutConstraint.constraints(
            formats: ["V:|[count][extra]-8-[slider]|",
                      "H:|[slider]|",
                      "H:|[count]|",
                      "H:|[extra]|"],
            views: ["slider": slider,
                    "count": countLabel,
                    "extra": extraLabel]
        ).activate()
    }
    
    @objc func sliderValueDidChange(sender: UISlider) {
        value = Int(sender.value)
        delegate?.sliderValueDidChange(value: Int(sender.value))
    }

}
