//
//  ViewController.swift
//  Attendance
//
//  Created by Cal Stephens on 9/15/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var inputView: NSView!
    @IBOutlet weak var card: NSView!
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var firstName: NSTextField!
    @IBOutlet weak var lastName: NSTextField!
    @IBOutlet weak var rollbookNumber: NSTextField!
    
    @IBOutlet weak var statisticsView: NSView!
    @IBOutlet weak var percentPresent: NSTextField!
    @IBOutlet weak var percentExcused: NSTextField!
    @IBOutlet weak var percentAbsent: NSTextField!

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
        
        let attendanceToday = Member.all.map{ $0.attendanceToday ?? .absent }
        var stats: [Attendance : Int] = [:]
        
        attendanceToday.forEach {
            stats[$0] = (stats[$0] ?? 0) + 1
        }
        
        func countToPercentLabel(_ count: Int?, _ label: NSTextField) {
            let total = Member.all.count
            
            if total == 0 {
                label.stringValue = "0%"
                return
            }
            
            let fraction = Double(count ?? 0) / Double(total)
            let percent = Int(round(fraction * 100))
            label.stringValue = "\(percent)%"
        }
        
        countToPercentLabel(stats[.present], self.percentPresent)
        countToPercentLabel(stats[.excused], self.percentExcused)
        countToPercentLabel(stats[.absent], self.percentAbsent)
        
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.15
            context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            self.inputView.animator().alphaValue = 0.0
        }, completionHandler: {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.5
                context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                self.statisticsView.animator().alphaValue = 1.0
            }, completionHandler: nil)
        })
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
        self.currentMember.attendanceToday = attendance
        
        setUpForNextMember()
        playTransition(for: self.card)
    }

}

