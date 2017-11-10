//
//  TipViewController.swift
//  Split
//
//  Created by Connor Wybranowski on 11/9/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit
import WybroStarter

class TipViewController: UIViewController {
    
    lazy var moneyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "bill amount"
        textField.keyboardType = .decimalPad
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textAlignment = .center
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        textField.backgroundColor = .white
        textField.keyboardAppearance = .dark
        
        let tipBar = TipBarView(height: 50)
        textField.inputAccessoryView = tipBar
        
//        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
//        customView.backgroundColor = .red
//        textField.inputAccessoryView = customView
        return textField
    }()
    
    lazy var resultsBar: ResultsBarView = .init()
    
//    lazy var tipBar: TipBarView = .init()
    
    lazy var peopleSlider: PeopleSliderView = .init()
    
    func setup() {
        view.backgroundColor = .white
        
        peopleSlider.delegate = self
        
        view.addSubview(moneyTextField.usingConstraints())
        view.addSubview(resultsBar.usingConstraints())
//        view.addSubview(tipBar.usingConstraints())
        view.addSubview(peopleSlider.usingConstraints())
        
        layoutConstraints().activate()
    }
    
    func layoutConstraints() -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(
            formats: ["H:|-[textField]-|",
                      "V:|-8-[textField]-[results]-[slider]",
                      "H:|[results]|",
                      "H:|-60-[slider]-60-|"],
            views: ["textField":  moneyTextField,
                    "results": resultsBar,
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
extension TipViewController: PeopleSliderDelegate {
    func sliderValueDidChange(value: Int) {
        print("value: \(value)")
    }
}

