//
//  NSLayoutConstraint+Extensions.swift
//  WybroStarter
//
//  Created by Connor Wybranowski on 10/21/17.
//  Copyright © 2017 wybro. All rights reserved.
//

import Foundation

public extension NSLayoutConstraint {
    public class func constraints(formats: [String],
                           options: NSLayoutFormatOptions = [],
                           metrics: [String : Any]? = nil,
                           views: [String : Any]) -> [NSLayoutConstraint] {
        
        var constraints = [[NSLayoutConstraint]]()
        formats.forEach { format in
            constraints.append(NSLayoutConstraint.constraints(withVisualFormat: format,
                                                              options: options,
                                                              metrics: metrics,
                                                              views: views))
        }
        
        return constraints.flatMap { $0 }
    }
    
    public func activate() {
        self.isActive = true
    }
}

public extension Array where Element == NSLayoutConstraint {
    public func activate() {
        NSLayoutConstraint.activate(self)
    }
}
