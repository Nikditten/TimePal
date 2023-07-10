//
//  Date+Extensions.swift
//  TimePal
//
//  Created by Niklas Børner on 10/07/2023.
//

import SwiftUI

extension Date {
    
    func formatAsDate() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: self)
    }
    
    func countdown() -> Int {
        let diffs = Calendar.current.dateComponents([.day], from: Date(), to: self)
        
        return diffs.day!
    }
    
    func countup() -> Int {
        let diffs = Calendar.current.dateComponents([.day], from: self, to: Date())
        
        return diffs.day!
    }
    
    func greet() -> String {
        let hour = Calendar.current.dateComponents([.hour], from: Date(), to: self).hour!
        
        if (hour < 12) {
            return "Good Morning!"
        }  else if (hour < 18) {
            return "Good Afternoon!"
        } else {
            return "Good evening"
        }
    }
    
}
