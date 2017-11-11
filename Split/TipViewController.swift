//
//  TipViewController.swift
//  Split
//
//  Created by Connor Wybranowski on 11/9/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit
import WybroStarter
import StoreKit

class TipViewController: UIViewController {
    
    enum Constants {
        static let green = UIColor(hex: "2CEAA3")
    }
    
    lazy var moneyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Cost"
        textField.keyboardType = .decimalPad
        textField.font = UIFont(name: "Barlow", size: 20)
        textField.textAlignment = .center
        textField.autocorrectionType = .no
//        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.keyboardAppearance = .dark
        
        textField.addTarget(self,
                            action: #selector(TipViewController.textFieldDidChange(sender:)),
                            for: .editingChanged)
        return textField
    }()
    
    lazy var tipBar: UISegmentedControl = {
        let control = UISegmentedControl(items: ["15%", "20%", "25%"])
        control.selectedSegmentIndex = 1
        control.tintColor = Constants.green
        control.addTarget(self, action: #selector(TipViewController.selectedSegmentDidChange(sender:)), for: .valueChanged)
        let attr = NSDictionary(object: UIFont(name: "Barlow", size: 16.0)!, forKey: NSAttributedStringKey.font as NSCopying)
        control.setTitleTextAttributes(attr as [NSObject : AnyObject], for: .normal)
        return control
    }()
    
    lazy var resultsBar: ResultsBarView = .init()
    
    lazy var peopleSlider: PeopleSliderView = {
        let slider = PeopleSliderView()
        slider.sliderColor = Constants.green
        return slider
    }()
    
    var backingNumPeople: Int = 1
    var backingCostValue: Double = 0.00
    var backingTipValue: Double = 0.20
    
    var numPeople: Int {
        get {
            return backingNumPeople
        } set {
            backingNumPeople = newValue
            computeBill()
        }
    }
    
    var costValue: Double {
        get {
            return backingCostValue
        } set {
            backingCostValue = newValue
            computeBill()
        }
    }
    
    var tipValue: Double {
        get {
            return backingTipValue
        } set {
            backingTipValue = newValue
            computeBill()
        }
    }
    
    func setup() {
        view.backgroundColor = .white
        
        let reviewButton = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: self, action: #selector(TipViewController.requestReview))
        reviewButton.tintColor = Constants.green
        navigationItem.leftBarButtonItem = reviewButton
        
        peopleSlider.delegate = self
        
        view.addSubview(moneyTextField.usingConstraints())
        view.addSubview(resultsBar.usingConstraints())
        view.addSubview(tipBar.usingConstraints())
        view.addSubview(peopleSlider.usingConstraints())
        
        layoutConstraints().activate()
    }
    
    func layoutConstraints() -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(
            formats: ["H:|-[textField]-|",
                      "V:|-8-[textField]-[results]-[tipBar]-[slider]",
                      "H:|[results]|",
                      "H:|-60-[slider]-60-|",
                      "H:|[tipBar]|"],
            views: ["textField":  moneyTextField,
                    "results": resultsBar,
                    "tipBar": tipBar,
                    "slider": peopleSlider]
        )
    }
}

// MARK: - View Lifecycle
extension TipViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        moneyTextField.becomeFirstResponder()
    }
}

// MARK: - Delegates
extension TipViewController: PeopleSliderDelegate, UITextFieldDelegate {
    func sliderValueDidChange(value: Int) {
        numPeople = value
        value > 1 ? resultsBar.hideLabel(false) : resultsBar.hideLabel(true)
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
        costValue = Double(sender.text ?? "0.00") ?? 0.00
    }
    
    @objc func selectedSegmentDidChange(sender: UISegmentedControl) {
        let tipStr = (sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "20%")
        let cleanStr = tipStr.replacingOccurrences(of: "%", with: "")
        let tipVal = (Double(cleanStr) ?? 20.0) / 100.0
        tipValue = tipVal
    }
}

// MARK: - Core logic
extension TipViewController {
    func computeBill() {
        resultsBar.update(cost: costValue, tipNum: tipValue, numPeople: numPeople)
    }
}

// MARK: - Navigation
extension TipViewController {
    @objc func requestReview() {
        SKStoreReviewController.requestReview()
    }
}
