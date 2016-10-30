//
//  WindowTouchBarController.swift
//  Attendance
//
//  Created by Cal Stephens on 10/29/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Foundation
import AppKit


extension NSTouchBarItemIdentifier {
    static let absent = NSTouchBarItemIdentifier(rawValue: "tech.calstephens.attendance.absent")
    static let excused = NSTouchBarItemIdentifier(rawValue: "tech.calstephens.attendance.excused")
    static let present = NSTouchBarItemIdentifier(rawValue: "tech.calstephens.attendance.present")
}


@available(OSX 10.12.1, *)
class WindowTouchBarController : NSWindowController, NSTouchBarDelegate {
    
    //MARK: - Touch Bar
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [.absent, .excused, .present]
        
        return touchBar
    }
    
    
    //MARK: - Touch Bar Delegate
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        let item = NSCustomTouchBarItem(identifier: identifier)
        
        guard let viewController = self.contentViewController as? ViewController else { return nil }
        
        let labels: [NSTouchBarItemIdentifier : (String, Selector)] = [
            .absent : ("❌ Absent", #selector(ViewController.absentPressedOnTouchBar)),
            .excused : ("❔ Excused", #selector(ViewController.excusedPressedOnTouchBar)),
            .present : ("✅ Present", #selector(ViewController.presentPressedOnTouchBar))
        ]
        
        let (title, selector) = labels[identifier]!
        item.view = NSButton(title: title, target: viewController, action: selector)
        return item
    }
    
}
