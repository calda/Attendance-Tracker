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
    @IBOutlet weak var rollbookNumber: NSTextField!

    var currentMember: Member!
    
    
    //MARK: - Setup
    
    override func viewDidLayout() {
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.title = "GFM 9/21"
        self.view.window?.isMovableByWindowBackground = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpForNextMember()
        
        //populate views
        self.image.wantsLayer = true
        self.image.layer?.cornerRadius = 5.0
    }
    
    
    //MARK: - Controller
    
    func setUpForNextMember() {
        
        guard let currentMember = currentMember, let currentIndex = Member.all.index(of: currentMember) else {
            setUp(for: Member.all.first!)
            return
        }
        
        let nextIndex = currentIndex.advanced(by: 1)
        if abs(nextIndex.distance(to: Member.all.startIndex)) >= Member.all.count {
            finish()
            return
        }
        
        let nextMember = Member.all[nextIndex]
        self.setUp(for: nextMember)
    }
    
    func setUp(for member: Member) {
        self.currentMember = member
        self.image.image = member.image
        
        self.firstName.stringValue = member.firstName
        self.lastName.stringValue = member.lastName
        self.rollbookNumber.stringValue = member.rollbookString
        
        func updateLabelWeight(of label: NSTextField, to weight: CGFloat) {
            let size = label.font!.pointSize
            let font = NSFont.systemFont(ofSize: size, weight: weight)
            label.font = font
        }
        
        let firstNameWeight = (member.isPledge ? NSFontWeightMedium : NSFontWeightLight)
        updateLabelWeight(of: self.firstName, to: firstNameWeight)
        
        let lastNameWeight = (member.isPledge ? NSFontWeightLight : NSFontWeightMedium)
        updateLabelWeight(of: self.lastName, to: lastNameWeight)
    }
    
    func playTransition(for view: NSView) {
        let transition = CATransition()
        transition.duration = 0.15
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        
        self.card.layer?.add(transition, forKey: nil)
    }
    
    func finish() {
        self.card.alphaValue = 0.0
        playTransition(for: self.card)
    }
    
    
    //MARK: - User Interaction
    
    override func keyUp(with event: NSEvent) {
        print(event.keyCode)
        print(event.characters)
    }
    
    @IBAction func absentPressed(_ sender: NSButton) {
        processSelection(attendance: .absent)
    }
    
    @IBAction func excusedPressed(_ sender: NSButton) {
        processSelection(attendance: .excused)
    }
    
    @IBAction func presentPressed(_ sender: NSButton) {
        processSelection(attendance: .present)
    }
    
    func processSelection(attendance: Attendance) {
        setUpForNextMember()
        playTransition(for: self.card)
    }

}

