//
//  PinnedTimeEvent.swift
//  TimePal
//
//  Created by Niklas Børner on 10/07/2023.
//

import SwiftUI

struct PinnedTimeEvent: View {
    
    var timeEvent: TimeEvent

    
    var body: some View {
        VStack (spacing: 5) {
            
            ZStack {
                Circle()
                    .fill(Color(hex: timeEvent.color)!.gradient)
                
                DaysCount(dayCount: timeEvent.date.countdown(), isPinned: timeEvent.isPinned)
            }
            .foregroundColor(Color(hex: timeEvent.color)!.isLight ? Color.black : Color.white)
            .frame(height: UIScreen.screenWidth / 4)
            
            
            VStack(alignment: .center, spacing: 5) {
                
                Text(timeEvent.name)
                    .font(.subheadline)
                    .minimumScaleFactor(0.1)
                    .truncationMode(.tail)
                    .lineLimit(1)
                
                Text(timeEvent.date.formatAsDate())
                    .font(.caption)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .frame(height: 50)
            
            
        }
        .frame(width: UIScreen.screenWidth / 4)
    }
}

struct PinnedTimeEvent_Previews: PreviewProvider {
    static var previews: some View {
        PinnedTimeEvent(timeEvent: TimeEvent())
    }
}
