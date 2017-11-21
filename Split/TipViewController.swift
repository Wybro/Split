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
        static var topPadding: CGFloat {
            return currentDevice == .iPhoneX ? 50 : 30
        }
        
        static var bottomPadding: CGFloat {
            return smallScreen ? UIScreen.main.bounds.height * 0.03 : UIScreen.main.bounds.height * 0.05
        }

        static let entryHeight = UIScreen.main.bounds.height * 0.4
    }

    lazy var resultsBar: ResultsBarView = .init()
    lazy var peopleStepper: PeopleStepperView = .init()
    lazy var keypad: KeypadView = .init()
    lazy var entryView: EntryView = .init()
    lazy var reviewButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(TipViewController.requestReview), for: .touchUpInside)
        button.setBackgroundImage(#imageLiteral(resourceName: "heart"), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 3
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.bouncyTouch()
        return button
    }()
    
    var numPeople: Int = 1 {
        didSet { computeBill() }
    }
    
    var costValue: Double = 0.00 {
        didSet { computeBill() }
    }
    
    var tipValue: Double = 0.20 {
        didSet { computeBill() }
    }

    func setup() {
        view.backgroundColor = Constants.green

        entryView.delegate = self
        peopleStepper.delegate = self
        resultsBar.tipView.delegate = self

        view.addSubview(resultsBar.usingConstraints())
        view.addSubview(peopleStepper.usingConstraints())
        view.addSubview(entryView.usingConstraints())
        view.addSubview(reviewButton.usingConstraints())
        
        view.bringSubview(toFront: resultsBar)

        peopleStepper.center(in: view, type: .horizontal).activate()

        layoutConstraints().activate()
    }

    func layoutConstraints() -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(
            formats: ["V:|-top-[review]-8-[results]",
                      "V:[stepper]-15-[entry(entryHeight)]-bottom-|",
                      "H:[review]-|",
                      "H:|[results]|",
                      "H:|[entry]|"],
            metrics: ["top": Metrics.topPadding,
                      "bottom": Metrics.bottomPadding,
                      "entryHeight": Metrics.entryHeight],
            views: ["results": resultsBar,
                    "stepper": peopleStepper,
                    "entry": entryView,
                    "review": reviewButton]
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
    
    func didStartTyping() {
        if resultsBar.tipView.enabled { resultsBar.tipView.toggle() }
        if peopleStepper.countEngaged { peopleStepper.toggle() }
    }
    
    func didToggleTipView() {
        if peopleStepper.countEngaged { peopleStepper.toggle() }
    }
    
    func didToggleStepper() {
        if resultsBar.tipView.enabled { resultsBar.tipView.toggle() }
    }

    func stepperDidChange(value: Int) {
        numPeople = value
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
