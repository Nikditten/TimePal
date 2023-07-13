//
//  DaysCount.swift
//  TimePal
//
//  Created by Niklas Børner on 13/07/2023.
//

import SwiftUI

struct DaysCount: View {
    
    var dayCount: Int
    var isPinned: Bool
    
    var body: some View {
        if (dayCount < 0) {
          Image(systemName: "party.popper")
                .bold()
                .font(isPinned ? .largeTitle : .title2)
                .minimumScaleFactor(0.1)
        } else {
            VStack (spacing: 2) {
                Text(dayCount.toString())
                    .bold()
                    .font(.largeTitle)
                
                if (isPinned) {
                    Text("DAYS")
                        .font(.caption)
                }
            }
            .minimumScaleFactor(0.1)
        }
    }
}

struct DaysCount_Previews: PreviewProvider {
    static var previews: some View {
        DaysCount(dayCount: 0, isPinned: false)
    }
}
