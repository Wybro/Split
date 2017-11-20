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

    lazy var tipBar: UISegmentedControl = {
        let control = UISegmentedControl(items: ["15%", "20%", "25%"])
        control.selectedSegmentIndex = 1
        control.tintColor = .white
        control.addTarget(self, action: #selector(TipViewController.selectedSegmentDidChange(sender:)), for: .valueChanged)
        let attr = NSDictionary(object: UIFont(name: "Barlow", size: 16.0)!, forKey: NSAttributedStringKey.font as NSCopying)
        control.setTitleTextAttributes(attr as [NSObject : AnyObject], for: .normal)
        return control
    }()

    lazy var resultsBar: ResultsBarView = .init()

    lazy var peopleStepper: PeopleStepperView = .init()

    lazy var keypad: KeypadView = .init()

    lazy var entry: EntryView = .init()

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
        view.backgroundColor = Constants.green

        let reviewButton = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: self, action: #selector(TipViewController.requestReview))
        reviewButton.tintColor = Constants.green
        navigationItem.leftBarButtonItem = reviewButton
        navigationController?.navigationBar.barTintColor = Constants.gray

        entry.delegate = self
        peopleStepper.delegate = self

        view.addSubview(resultsBar.usingConstraints())
        view.addSubview(tipBar.usingConstraints())
        view.addSubview(peopleStepper.usingConstraints())
        view.addSubview(entry.usingConstraints())
        
        peopleStepper.center(in: view, type: .horizontal).activate()

        layoutConstraints().activate()
    }

    func layoutConstraints() -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(
            formats: ["V:|-8-[results]-[tipBar]-40-[stepper]",
                      "V:[entry(350)]-40-|",
                      "H:|[results]|",
                      "H:|[tipBar]|",
                      "H:|[entry]|"],
            views: ["results": resultsBar,
                    "tipBar": tipBar,
                    "stepper": peopleStepper,
                    "entry": entry]
        )
    }
}

// MARK: - View Lifecycle
extension TipViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Delegates
extension TipViewController: EntryViewDelegate, PeopleStepperDelegate {
    func costDidChange(value: Double) {
        costValue = value
    }

    func stepperDidChange(value: Int) {
        numPeople = value
        value > 1 ? resultsBar.hideLabel(false) : resultsBar.hideLabel(true)
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
