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
        slider.sliderColor = UIColor.white
        return slider
    }()
    
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

        peopleSlider.delegate = self
        entry.delegate = self

        view.addSubview(resultsBar.usingConstraints())
        view.addSubview(tipBar.usingConstraints())
        view.addSubview(peopleSlider.usingConstraints())
        view.addSubview(entry.usingConstraints())

        layoutConstraints().activate()
    }

    func layoutConstraints() -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(
            formats: ["V:|-8-[results]-[tipBar]-[slider]",
                      "V:[entry(350)]-20-|",
                      "H:|[entry]|",
                      "H:|[results]|",
                      "H:|-60-[slider]-60-|",
                      "H:|[tipBar]|"],
            views: ["results": resultsBar,
                    "tipBar": tipBar,
                    "slider": peopleSlider,
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
extension TipViewController: PeopleSliderDelegate, EntryViewDelegate {
    func costDidChange(value: Double) {
        costValue = value
    }
    
    func sliderValueDidChange(value: Int) {
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
