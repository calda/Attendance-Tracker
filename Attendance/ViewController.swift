//
//  ViewController.swift
//  Attendance
//
//  Created by Cal Stephens on 9/15/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var card: NSView!
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var firstName: NSTextField!
    @IBOutlet weak var lastName: NSTextField!

    var currentMember: Member!
    
    
    //MARK: - Setup
    
    override func viewDidLayout() {
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.titleVisibility = .hidden
        self.view.window?.isMovableByWindowBackground = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up card
        self.view.wantsLayer = true
        self.view.superview?.wantsLayer = true
        self.card.wantsLayer = true
        
        self.card.shadow = NSShadow()
        
        self.card.layer?.backgroundColor = NSColor.white.cgColor
        self.card.layer?.cornerRadius = 10.0
        
        self.card.layer?.shadowOpacity = 0.2
        self.card.layer?.shadowColor = NSColor.black.cgColor
        self.card.layer?.shadowOffset = NSMakeSize(0, 15)
        
        let shadowRect = CGRect(x: 0, y: -10, width: self.card.bounds.width, height: self.card.bounds.height - 10)
        self.card.layer?.shadowPath = CGPath(roundedRect: shadowRect, cornerWidth: 10, cornerHeight: 10, transform: nil)
        self.card.layer?.shadowRadius = 10
        
        //populate views
        self.image.wantsLayer = true
        self.image.layer?.cornerRadius = 5.0
        
    }
    
    
    //MARK: - Controller
    
    func setUpForNextMember() {
        guard let currentIndex = Member.all.index(of: currentMember) else {
            setUp(forMember: Member.all.first!)
        }
        

    }
    
    func setUp(forMember member: Member) {
        self.currentMember = member
        
        let image
    }
    
    
    //MARK: - User Interaction
    
    @IBAction func absentPressed(_ sender: NSButton) {
    }
    
    @IBAction func excusedPressed(_ sender: NSButton) {
    }
    
    @IBAction func presentPressed(_ sender: NSButton) {
    }
    
    func processSelection(attendance: Attendance) {
        setUp(forMember: <#T##Member#>)
    }

    
    
    


}

