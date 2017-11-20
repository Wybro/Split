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

    enum Metrics {
        static var bottomPadding: CGFloat {
            return smallScreen ? UIScreen.main.bounds.height * 0.03 : UIScreen.main.bounds.height * 0.05
        }

        static let entryHeight = UIScreen.main.bounds.height * 0.4
    }

    lazy var resultsBar: ResultsBarView = .init()

    lazy var peopleStepper: PeopleStepperView = .init()

    lazy var keypad: KeypadView = .init()

    lazy var entryView: EntryView = .init()

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

        entryView.delegate = self
        peopleStepper.delegate = self
        resultsBar.tipView.delegate = self

        view.addSubview(resultsBar.usingConstraints())
        view.addSubview(peopleStepper.usingConstraints())
        view.addSubview(entryView.usingConstraints())

        peopleStepper.center(in: view, type: .horizontal).activate()

        layoutConstraints().activate()
    }

    func layoutConstraints() -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(
            formats: ["V:|-8-[results]",
                      "V:[stepper]-20-[entry(entryHeight)]-bottom-|",
                      "H:|[results]|",
                      "H:|[entry]|"],
            metrics: ["bottom": Metrics.bottomPadding,
                      "entryHeight": Metrics.entryHeight],
            views: ["results": resultsBar,
                    "stepper": peopleStepper,
                    "entry": entryView]
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
extension TipViewController: EntryViewDelegate, PeopleStepperDelegate, TipViewDelegate {
    func tipDidChange(value: Double) {
        tipValue = value
    }
    
    func costDidChange(value: Double) {
        costValue = value
    }

    func stepperDidChange(value: Int) {
        numPeople = value
//        value > 1 ? resultsBar.hideLabel(false) : resultsBar.hideLabel(true)
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
