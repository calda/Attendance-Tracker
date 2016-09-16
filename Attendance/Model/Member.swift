//
//  Member.swift
//  Attendance
//
//  Created by Cal Stephens on 9/15/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import AppKit

enum Attendance {
    case present, excused, absent
}

func ==(left: Member, right: Member) -> Bool {
    return left.description == right.description
}

class Member : CustomStringConvertible, Equatable {
    
    //MARK: - Load from disk
    
    static var all: [Member] {
        guard let path = Bundle.main.path(forResource: "People", ofType: "csv") else { return [] }
        let url = URL(fileURLWithPath: path)
        guard let contents = try? NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue) else { return [] }
        
        let lines = contents.components(separatedBy: "\n").filter{ $0.contains(",") }
        
        let people = lines.map { line -> Member in
            //format: "Cal Stephens, 810"
            let cols = line.components(separatedBy: ", ")
            
            let name = cols[0]
            let nameComponents = name.components(separatedBy: " ")
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            
            let rollbookString = cols[1]
            let rollbook = Int(rollbookString)
            
            return Member(firstName: firstName, lastName: lastName, rollbook: rollbook)
        }
        
        return people
    }
    
    
    //MARK: - Properties
    
    let firstName: String
    let lastName: String
    
    let rollbook: Int?
    
    let attendance: [String : Attendance]
    var attendanceToday: Attendance?
    
    init(firstName: String, lastName: String, rollbook: Int?) {
        self.firstName = firstName
        self.lastName = lastName
        self.rollbook = rollbook
        
        attendance = [:]
    }
    
    
    //MARK: - Dyanamic Properties
    
    var isPledge: Bool {
        return rollbook == nil
    }
    
    var rollbookString: String {
        guard let rollbook = rollbook else { return "Pledge" }
        return "#\(rollbook)"
    }
    
    var description: String {
        return "\(firstName) \(lastName) (\(rollbookString))"
    }
    
    var image: NSImage? {
        let fileName = "\(firstName) \(lastName)"
        return NSImage(named: "\(fileName).jpg") ?? NSImage(named: "\(fileName).png")
    }
    
}
