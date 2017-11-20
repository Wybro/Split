//
//  UIView+Extensions.swift
//  Split
//
//  Created by Connor Wybranowski on 11/19/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

extension UIView {
    enum Intensity {
        case light, medium, hard
    }
    
    func shake(_ amount: Intensity = .hard) {
        var scale: CGFloat = 0
        var duration: TimeInterval = 0
        
        switch amount {
        case .light:
            scale = 1.05
            duration = 0.2
        case .medium:
            scale = 1.075
            duration = 0.15
        case .hard:
            scale = 1.1
            duration = 0.1
        }
        
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
}
