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
    
    var body: some View {
        NavigationView {
            VStack {
                LazyVGrid (columns: [GridItem(.flexible()),
                                     GridItem(.flexible()),
                                     GridItem(.flexible())]) {
                    ForEach(dataSource.timeEventsArray.filter { $0.isPinned }) { timeEvent in
                        PinnedTimeEvent(timeEvent: timeEvent)
                            .padding(5)
                            .contextMenu {
                                Button(action: {
                                    withAnimation {
                                        var updatedTimeEvent: TimeEvent = timeEvent
                                        updatedTimeEvent.isPinned = false
                                        dataSource.updateAndSave(timeEvent: updatedTimeEvent)
                                    }
                                }, label: {
                                    Label("Unpin", systemImage: "pin.slash")
                                })
                                
                                Button(action: {}, label: {
                                    Label("Edit", systemImage: "pencil")
                                })
                                
                                Button(role: .destructive, action: {
                                    withAnimation {
                                        dataSource.delete(timeEvent: timeEvent)
                                    }
                                }, label: {
                                    Label("Delete", systemImage: "trash")
                                })
                            }
                    }
                }
                List {
                    ForEach(dataSource.timeEventsArray.filter { !$0.isPinned }) { timeEvent in
                        ListedTimeEvent(timeEvent: timeEvent)
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
                                    withAnimation {
                                        var updatedTimeEvent: TimeEvent = timeEvent
                                        updatedTimeEvent.isPinned = true
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
