//
//  DefaultsService.swift
//  Split
//
//  Created by Kyle Wybranowski on 11/10/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import Foundation

struct DefaultsService {
    
    enum Values: String {
        case left, right, center
    }
    
    static func setTipValue(position: Values , value: Int) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: position.rawValue)
    }
    
    static func getTipValue(position: Values) -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: position.rawValue)
    }
    
    
}
