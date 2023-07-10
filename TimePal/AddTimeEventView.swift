//
//  AddTimeEventView.swift
//  TimePal
//
//  Created by Niklas Børner on 07/07/2023.
//

import SwiftUI

struct AddTimeEventView: View {
    
    @Binding var isPresented: Bool
    
    @State var newTimeEvent: TimeEvent = TimeEvent()
    
    @State var color: Color = Color("DarkOrange")
    
    @ObservedObject private var dataSource: DataSource
    
    init(dataSource: DataSource = DataSource.shared, isPresented: Binding<Bool>) {
        self.dataSource = dataSource
        self._isPresented = isPresented
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section {
                    TextField("Name", text: $newTimeEvent.name)
                        .keyboardType(.default)
                    
                    Toggle("Streak", isOn: $newTimeEvent.isStreak)
                }
                
                Section {
                    DatePicker(newTimeEvent.isStreak ? "Streak starts" : "Countdown to", selection: $newTimeEvent.date, displayedComponents: .date)
                }
                
                Section {
                    ColorPicker("Give it a color", selection: $color, supportsOpacity: false)
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button{
                        newTimeEvent.color = color.toHex()!
                        withAnimation {
                            dataSource.updateAndSave(timeEvent: newTimeEvent)
                        }
                        isPresented.toggle()
                    } label: {
                        Text("Let's get counting")
                            .foregroundColor(Color("DarkOrange"))
                    }
                }
            }
        }
    }
}

struct AddTimeEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddTimeEventView(isPresented: .constant(true))
    }
}
