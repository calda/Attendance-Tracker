//
//  ShadowView.swift
//  Attendance
//
//  Created by Cal Stephens on 9/15/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import AppKit

class ShadowView : NSView {
    
    override func viewWillDraw() {
        super.viewWillDraw()
        
        self.superview?.wantsLayer = true
        self.wantsLayer = true
        
        self.shadow = NSShadow()
        
        self.layer?.backgroundColor = NSColor.white.cgColor
        self.layer?.cornerRadius = 10.0
        
        self.layer?.shadowOpacity = 0.2
        self.layer?.shadowColor = NSColor.black.cgColor
        self.layer?.shadowOffset = NSMakeSize(0, -10)
        
        self.layer?.shadowPath = CGPath(roundedRect: self.bounds, cornerWidth: 10, cornerHeight: 10, transform: nil)
        self.layer?.shadowRadius = 10
    }
    
}
