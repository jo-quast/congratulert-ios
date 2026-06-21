import SwiftUI

/// A single row displaying key info for a ``Reminder``.
struct ReminderRow: View {

    let reminder: Reminder
    
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 16
    static let hStackSpacing: CGFloat = 12
    static let avatarDiameter: CGFloat = 48

    // MARK: - Body

    var body: some View {
        HStack(spacing: Self.hStackSpacing) {
            avatar
            details
            Spacer()
            countdown
            Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color(.systemGray3))
        }
        .padding(.horizontal, Self.horizontalPadding)
        .padding(.vertical, Self.verticalPadding)
    }

    // MARK: - Subviews

    /// Initials avatar derived from the reminder's person name.
    private var avatar: some View {
        Text(reminder.type.icon)
            .font(.system(size: 24, weight: .medium))
            .frame(width: Self.avatarDiameter, height: Self.avatarDiameter)
            .background(reminder.type.color.opacity(0.20))
            .clipShape(Circle())
    }

    /// Core reminder information
    private var details: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(reminder.name)
                .font(.subheadline.weight(.medium))
            Text(reminder.dateString() + (reminder.yearsSince().map { " · \($0) years" } ?? ""))
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
    
    static var avatarWidth: CGFloat {
        horizontalPadding + avatarDiameter + hStackSpacing
    }
}

#Preview {
    ReminderRow(reminder: Reminder.sampleData[0])
}
