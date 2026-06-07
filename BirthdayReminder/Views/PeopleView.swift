import SwiftUI

/// Displays all tracked people with inline search.
struct PeopleView: View {

    /// Text entered into the search field.
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            Text("People list goes here")
                .navigationTitle("People")
                .searchable(text: $searchText, prompt: "Search people")
        }
    }
}
