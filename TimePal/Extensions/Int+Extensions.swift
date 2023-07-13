//
//  Int+Extensions.swift
//  TimePal
//
//  Created by Niklas Børner on 10/07/2023.
//

import Foundation

extension Int {
    func toString() -> String {
        return String(self)
    }
    
    func textSize() -> CGFloat {
        let length = self.toString().count
        
        if (length == 5) {
            return 12
        } else if (length == 4) {
            return 14
        } else if (length == 3) {
            return 16
        } else {
            return 18
        }
    }
}
