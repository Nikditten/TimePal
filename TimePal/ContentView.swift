//
//  ContentView.swift
//  TimePal
//
//  Created by Niklas Børner on 07/07/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var showAddSheet: Bool = false
    
    @ObservedObject private var dataSource: DataSource
    
    init(dataSource: DataSource = DataSource.shared) {
        self.dataSource = dataSource
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let timeEvent = dataSource.timeEventsArray[index]
            dataSource.delete(timeEvent: timeEvent)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                LazyVGrid (columns: [GridItem(), GridItem(), GridItem()], spacing: 15) {
                    ForEach(dataSource.timeEventsArray.filter { $0.isStreak }) { timeEvent in
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
                }.padding()
                List {
                    ForEach(dataSource.timeEventsArray.filter { !$0.isStreak }) { timeEvent in
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
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button (role: .destructive) {
                                withAnimation {
                                    dataSource.delete(timeEvent: timeEvent)
                                }
                            } label: {
                                Image(systemName: "trash")
                            }
                            
                            Button () {} label: {
                                Image(systemName: "pencil")
                            }
                            .tint(Color("LightOrange"))
                        }
                        .swipeActions (edge: .leading, allowsFullSwipe: true) {
                            Button {
                                var updatedTimeEvent: TimeEvent = timeEvent
                                updatedTimeEvent.isPinned.toggle()
                                withAnimation {
                                    dataSource.updateAndSave(timeEvent: updatedTimeEvent)
                                }
                            } label: {
                                Image(systemName: "pin")
                            }
                            .tint(Color("DarkBlue"))
                        }
                    }
                }
                .listStyle(.plain)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showAddSheet.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color("DarkOrange"))
                    })
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddTimeEventView(isPresented: $showAddSheet)
                .presentationDetents([.fraction(0.50)])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
