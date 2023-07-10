//
//  ListedTimeEvent.swift
//  TimePal
//
//  Created by Niklas Børner on 10/07/2023.
//

import SwiftUI

struct ListedTimeEvent: View {
    
    var timeEvent: TimeEvent
    
    var body: some View {
        HStack (spacing: 15) {
            
            ZStack {
                Circle()
                    .fill(Color(hex: timeEvent.color)!.gradient)
                VStack(spacing: 2) {
                    Text((timeEvent.isStreak ? timeEvent.date.countup() : timeEvent.date.countdown()).toString())
                        .bold()
                        .font(.subheadline)
                    Text("DAYS")
                        .font(.footnote)
                }
                .minimumScaleFactor(0.1)
            }
            .foregroundColor(Color(hex: timeEvent.color)!.isLight ? Color.black : Color.white)
            
            VStack(alignment: .leading, spacing: 7.5) {
                
                Text(timeEvent.name)
                    .font(.title2)
                    .minimumScaleFactor(0.1)
                    .truncationMode(.tail)
                
                Text(timeEvent.date.formatAsDate())
                    .font(.subheadline)
                    .minimumScaleFactor(0.1)
                    .truncationMode(.tail)
            }
            
            Spacer()
            
            Image(systemName: timeEvent.isStreak ? "arrow.up" : "arrow.down")
                .font(.title)
            
        }
        .frame(height: 60)
        .listRowSeparator(.hidden)
    }
}

struct ListedTimeEvent_Previews: PreviewProvider {
    static var previews: some View {
        ListedTimeEvent(timeEvent: TimeEvent())
    }
}
