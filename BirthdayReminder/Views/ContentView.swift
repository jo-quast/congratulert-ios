//
//  ContentView.swift
//  BirthdayReminder
//
//  Created by Jonathan Quast on 24.05.26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var birthdays: [Birthday]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(birthdays) { birthday in
                    NavigationLink {
                        Text(birthday.name)
                    } label: {
                        Text(birthday.name)
                    }
                }
                .onDelete(perform: deleteBirthday)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addBirthday) {
                        Label("Add Birthday", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a Birthday")
        }
    }

    private func addBirthday() {
        withAnimation {
            let newBirthday = Birthday(name: "", date: Date(), notes: "Test")
            modelContext.insert(newBirthday)
        }
    }

    private func deleteBirthday(offsets: IndexSet) {
        withAnimation {
            // TODO
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Birthday.self, inMemory: true)
}
