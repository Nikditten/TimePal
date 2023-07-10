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
                VStack(spacing: 2) {
                    Text((timeEvent.isStreak ? timeEvent.date.countup() : timeEvent.date.countdown()).toString())
                        .bold()
                        .font(.title2)
                    Text("DAYS")
                        .font(.subheadline)
                }
                .minimumScaleFactor(0.1)
            }
            .foregroundColor(Color(hex: timeEvent.color)!.isLight ? Color.black : Color.white)
            .frame(height: UIScreen.screenWidth / 4)
            
            
            VStack(alignment: .center, spacing: 5) {
                
                HStack {
                    Text(timeEvent.name)
                        .font(.subheadline)
                        .minimumScaleFactor(0.1)
                        .truncationMode(.tail)
                    Image(systemName: timeEvent.isStreak ? "arrow.up" : "arrow.down")
                        .font(.subheadline)
                }
                
                Text(timeEvent.date.formatAsDate())
                    .font(.caption)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            
        }
        .frame(width: UIScreen.screenWidth / 4)
    }
}

struct PinnedTimeEvent_Previews: PreviewProvider {
    static var previews: some View {
        PinnedTimeEvent(timeEvent: TimeEvent())
    }
}
