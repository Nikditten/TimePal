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
        HStack (spacing: 10) {
            
            Circle()
                .fill(Color(hex: timeEvent.color)!.gradient)
                .overlay {
                    DaysCount(dayCount: timeEvent.date.countdown(), isPinned: timeEvent.isPinned)
                        .foregroundColor(Color(hex: timeEvent.color)!.isLight ? Color.black : Color.white)
                        .padding(10)
                }
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text(timeEvent.name)
                    .bold()
                    .font(.subheadline)
                    .minimumScaleFactor(0.1)
                    .truncationMode(.tail)
                    .lineLimit(1)
                
                Text(timeEvent.date.formatAsDate())
                    .font(.caption)
                    .foregroundColor(.gray)
                    .minimumScaleFactor(0.1)
                    .truncationMode(.tail)
                    .lineLimit(1)
            }
            
            Spacer()
            
        }
        .frame(height: 50)
        .listRowSeparator(.hidden)
    }
}

struct ListedTimeEvent_Previews: PreviewProvider {
    static var previews: some View {
        ListedTimeEvent(timeEvent: TimeEvent())
    }
}
