import SwiftUI

/// Displays all upcoming reminders sorted by proximity to today.
struct HomeView: View {
    var body: some View {
        NavigationStack {
            Text("Upcoming reminders go here")
                .navigationTitle("Upcoming")
        }
    }
}
