import SwiftUI

/// Root view containing the main tab bar navigation.
struct ContentView: View {

    /// Tracks the currently selected tab.
    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            ReminderView()
                .tabItem {
                    Label("Reminders", systemImage: "calendar.badge.clock")
                }
                .tag(Tab.home)

            PeopleView()
                .tabItem {
                    Label("People", systemImage: "person.2")
                }
                .tag(Tab.people)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(Tab.settings)
        }
        .onAppear {
            applyTabBarAppearance()
        }
    }
    
    private func applyTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        let item = UITabBarItemAppearance()

        // Selected state — soft rose
        item.selected.iconColor = UIColor(Color.appPrimaryDark)
        item.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.appPrimaryDark)
        ]

        // Unselected state — muted lavender-grey
        item.normal.iconColor = UIColor(Color.appPrimary)
        item.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.appPrimary)
        ]

        appearance.stackedLayoutAppearance = item
        appearance.inlineLayoutAppearance = item
        appearance.compactInlineLayoutAppearance = item

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

/// Represents each destination in the main tab bar.
enum Tab {
    case home, people, settings
}
