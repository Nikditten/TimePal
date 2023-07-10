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
    
}
