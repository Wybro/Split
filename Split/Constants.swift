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

enum Device {
    case iPhone5, iPhone8, iPhone8Plus, iPhoneX, unknown
}

var currentDevice: Device {
    switch UIScreen.main.bounds.height {
    case 568: return .iPhone5
    case 667: return .iPhone8
    case 736: return .iPhone8Plus
    case 812: return .iPhoneX
    default: return .unknown
    }
}
