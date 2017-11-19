//
//  Constants.swift
//  Split
//
//  Created by Kyle Wybranowski on 11/18/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    static let green = UIColor(hex: "2CEAA3")
    static let gray = UIColor(hex: "586566")
    static let white = UIColor(hex: "FDFFE5")
}

var smallScreen: Bool {
    return UIScreen.main.bounds.height <= 667
}
