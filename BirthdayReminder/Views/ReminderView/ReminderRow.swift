import SwiftUI

/// A single row displaying key info for a ``Reminder``.
struct ReminderRow: View {

    let reminder: Reminder

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            avatar
            details
            Spacer()
            countdown
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }

    // MARK: - Subviews

    /// Initials avatar derived from the reminder's person name.
    private var avatar: some View {
        Text(reminder.type.icon)
            .font(.system(size: 24, weight: .medium))
            .frame(width: 48, height: 48)
            .background(reminder.type.color.opacity(0.20))
            .clipShape(Circle())
    }

    /// Name and event type label.
    private var details: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(reminder.name)
                .font(.subheadline.weight(.medium))
            Text(reminder.type.label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    /// Days-until badge colour-coded by urgency.
    private var countdown: some View {
        Text(reminder.daysUntilNextLabel)
            .font(.caption.weight(.medium))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.appSecondary.opacity(0.2))
            .foregroundStyle(Color.appSecondary)
            .clipShape(Capsule())
    }
}

#Preview {
    ReminderRow(reminder: Reminder.sampleData[0])
}
