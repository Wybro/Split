//
//  UIButton+Extensions.swift
//  Split
//
//  Created by Kyle Wybranowski on 11/21/17.
//  Copyright © 2017 Wybro LLC. All rights reserved.
//

import UIKit

extension UIButton {
    func bouncyTouch() {
        self.addTarget(self, action: #selector(shrink), for: .touchDown)
        self.addTarget(self, action: #selector(grow), for: [.touchDragOutside, .touchUpInside])
    }
    
    @objc private func shrink() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    @objc private func grow() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}
