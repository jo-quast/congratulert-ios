import SwiftUI
import SwiftData
import Contacts

/// Form to edit a ``Reminder``.
struct ReminderForm: View {
    @Binding var name: String
    @Binding var selectedType: ReminderType
    @Binding var selectedDay: Int
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int?
    @Binding var associatedContact: CNContact?
    @Binding var note: String?
    @Binding var showContactPicker: Bool
    
    // MARK: - Helper Functions
    
    /// Display string for the optional contact button.
    private var contactButtonLabel: String {
        guard let c = associatedContact else { return "Choose Contact" }
        return [c.givenName, c.familyName]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    /// The current calendar year, used as the upper bound of the year picker.
    private var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }
    
    /// Number of days valid for the selected month and year.
    private var daysInSelectedMonth: Int {
        // Use a leap year (2000) so February allows 29 days when year is unknown.
        let year = selectedYear ?? 2000
        let components = DateComponents(year: year, month: selectedMonth)
        let date = Calendar.current.date(from: components)!
        return Calendar.current
            .range(of: .day, in: .month, for: date)!.count
    }
    
    /// Clamps `selectedDay` if it exceeds the days available in the current month.
    private func clampDay() {
        if selectedDay > daysInSelectedMonth {
            selectedDay = daysInSelectedMonth
        }
    }
    
    /// Returns the full month name for a 1-based month index.
    private func monthName(_ month: Int) -> String {
        DateFormatter().monthSymbols[month - 1]
    }
    
    // MARK: - Body
    
    var body: some View {
        nameSection
        typeSection
        dateSection
        contactSection
        noteSection
    }
    
    // MARK: - Sections
    
    /// Free-text name field.
    private var nameSection: some View {
        Section("Name") {
            TextField("e.g. Paul's Birthday", text: $name)
                .autocorrectionDisabled()
        }
    }
    
    private var typeSection: some View {
        Section("Type") {
            Picker("Type", selection: $selectedType) {
                ForEach(ReminderType.allCases, id: \.self) { type in
                    Text("\(type.icon) \(type.label)").tag(type)
                }
            }
            .tint(.primary)
        }
    }
    
    private var dateSection: some View {
        Section("Date") {
            HStack(spacing: 0) {
                Picker("Day", selection: $selectedDay) {
                    ForEach(
                        1...daysInSelectedMonth,
                        id: \.self
                    ) { day in
                        Text("\(day)").tag(day)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 80)
                .clipped()
                .onChange(of: selectedMonth) { clampDay() }
                
                Picker("Month", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text(monthName(month)).tag(month)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .clipped()
                
                Picker("Year", selection: $selectedYear) {
                    Text("----").tag(Int?.none)
                    ForEach(
                        stride(from: currentYear, through: 1900, by: -1)
                            .map { $0
                            },
                        id: \.self) { year in
                            Text(String(year)).tag(Int?.some(year))
                        }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                .clipped()
            }
            .listRowInsets(
                EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            )
        }
    }
    
    /// Optional contact association.
    private var contactSection: some View {
        Section("Contact (optional)") {
            Button {
                showContactPicker = true
            } label: {
                HStack {
                    Label(
                        contactButtonLabel,
                        systemImage: "person.crop.circle"
                    )
                    Spacer()
                    if associatedContact != nil {
                        Button(role: .destructive) {
                            associatedContact = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .foregroundStyle(
                associatedContact == nil ? Color.appAccent : .primary
            )
        }
    }
    
    /// Optional note
    private var noteSection: some View {
        Section("Note (optional)") {
                TextField("Add a note…", text: Binding(
                    get: { note ?? "" },
                    set: { note = $0.isEmpty ? nil : $0 }
                ), axis: .vertical)
                .lineLimit(4...8)
                .autocorrectionDisabled()
            }
    }
}
