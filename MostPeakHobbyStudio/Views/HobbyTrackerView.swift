import SwiftUI

struct HobbyTrackerView: View {
    @EnvironmentObject private var viewModel: HobbyTrackerViewModel
    @State private var showAddSheet = false

    var body: some View {
        NavigationView {
            ZStack {
                Theme.navy.ignoresSafeArea()

                if viewModel.hobbies.isEmpty {
                    VStack(spacing: Theme.Spacing.lg) {
                        Spacer()
                        Text("🎨")
                            .font(.system(size: 64))
                        Text("No hobbies yet")
                            .font(.system(size: Theme.FontSize.title3, weight: .bold))
                            .foregroundStyle(Theme.white)
                        Text("Tap + to add your first hobby and start tracking your progress.")
                            .font(.system(size: Theme.FontSize.body))
                            .foregroundStyle(Theme.subtleText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.xl)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: Theme.Spacing.sm) {
                            ForEach(viewModel.hobbies) { hobby in
                                NavigationLink(destination: HobbyDetailView(hobby: hobby)) {
                                    HobbyCardView(hobby: hobby)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                        .padding(.vertical, Theme.Spacing.sm)
                        .padding(.bottom, Theme.Spacing.xl)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Hobby Tracker")
                        .font(.system(size: Theme.FontSize.title3, weight: .bold))
                        .foregroundStyle(Theme.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Theme.accent)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddHobbyView()
                    .environmentObject(viewModel)
            }
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Hobby Card

private struct HobbyCardView: View {
    let hobby: Hobby

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack(alignment: .top, spacing: Theme.Spacing.md) {
                    Text(hobby.emoji)
                        .font(.system(size: 32))
                        .frame(width: 52, height: 52)
                        .background(Theme.navy.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(hobby.name)
                            .font(.system(size: Theme.FontSize.body, weight: .bold))
                            .foregroundStyle(Theme.cardText)
                            .lineLimit(1)

                        if !hobby.description.isEmpty {
                            Text(hobby.description)
                                .font(.system(size: 13))
                                .foregroundStyle(Theme.cardText.opacity(0.6))
                                .lineLimit(2)
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(Int(hobby.progress * 100))%")
                            .font(.system(size: Theme.FontSize.title3, weight: .bold))
                            .foregroundStyle(Theme.accent)
                        Text("progress")
                            .font(.system(size: 11))
                            .foregroundStyle(Theme.cardText.opacity(0.5))
                    }
                }

                ProgressBar(value: hobby.progress, color: Theme.accent)

                if !hobby.goalDescription.isEmpty {
                    HStack(spacing: Theme.Spacing.xs) {
                        Image(systemName: "target")
                            .font(.caption)
                            .foregroundStyle(Theme.navy.opacity(0.5))
                        Text(hobby.goalDescription)
                            .font(.system(size: 13))
                            .foregroundStyle(Theme.cardText.opacity(0.6))
                            .lineLimit(1)
                    }
                }

                if !hobby.milestones.isEmpty {
                    HStack(spacing: Theme.Spacing.sm) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(hobby.completedMilestones > 0 ? .green : Theme.cardText.opacity(0.4))
                        Text("\(hobby.completedMilestones)/\(hobby.milestones.count) milestones")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Theme.cardText.opacity(0.6))
                    }
                }
            }
            .padding(Theme.Spacing.md)
        }
    }
}

// MARK: - Hobby Detail

struct HobbyDetailView: View {
    @EnvironmentObject private var viewModel: HobbyTrackerViewModel
    @State private var hobby: Hobby
    @State private var showEditSheet = false
    @State private var showAddMilestone = false
    @State private var newMilestoneTitle = ""
    @State private var sliderValue: Double
    @Environment(\.dismiss) private var dismiss

    init(hobby: Hobby) {
        _hobby = State(initialValue: hobby)
        _sliderValue = State(initialValue: hobby.progress)
    }

    private var currentHobby: Hobby {
        viewModel.hobbies.first(where: { $0.id == hobby.id }) ?? hobby
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.lg) {
                HobbyDetailHeaderView(hobby: currentHobby)
                ProgressSectionView(hobby: currentHobby, sliderValue: $sliderValue) { newValue in
                    viewModel.updateProgress(for: currentHobby, progress: newValue)
                }
                if !currentHobby.goalDescription.isEmpty {
                    GoalSectionView(goal: currentHobby.goalDescription)
                }
                MilestonesSectionView(
                    hobby: currentHobby,
                    showAddMilestone: $showAddMilestone,
                    newMilestoneTitle: $newMilestoneTitle,
                    onToggle: { milestone in viewModel.toggleMilestone(milestone, in: currentHobby) },
                    onAdd: { title in
                        var updated = currentHobby
                        updated.milestones.append(Hobby.Milestone(title: title))
                        viewModel.update(updated)
                    }
                )
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.md)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Theme.navy.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(currentHobby.name)
                    .font(.system(size: Theme.FontSize.body, weight: .bold))
                    .foregroundStyle(Theme.white)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Edit Hobby") { showEditSheet = true }
                    Button("Delete Hobby", role: .destructive) {
                        viewModel.delete(currentHobby)
                        dismiss()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(Theme.white)
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EditHobbyView(hobby: currentHobby)
                .environmentObject(viewModel)
        }
    }
}

private struct HobbyDetailHeaderView: View {
    let hobby: Hobby

    var body: some View {
        CardView {
            HStack(spacing: Theme.Spacing.md) {
                Text(hobby.emoji)
                    .font(.system(size: 48))
                    .frame(width: 72, height: 72)
                    .background(Theme.navy.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))

                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text(hobby.name)
                        .font(.system(size: Theme.FontSize.title2, weight: .bold))
                        .foregroundStyle(Theme.cardText)

                    if !hobby.description.isEmpty {
                        Text(hobby.description)
                            .font(.system(size: Theme.FontSize.body))
                            .foregroundStyle(Theme.cardText.opacity(0.7))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Text("Since \(hobby.dateCreated.formatted(date: .abbreviated, time: .omitted))")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.cardText.opacity(0.45))
                }

                Spacer()
            }
            .padding(Theme.Spacing.md)
        }
    }
}

private struct ProgressSectionView: View {
    let hobby: Hobby
    @Binding var sliderValue: Double
    let onChanged: (Double) -> Void

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                Text("Progress")
                    .font(.system(size: Theme.FontSize.body, weight: .bold))
                    .foregroundStyle(Theme.cardText)

                HStack {
                    ProgressBar(value: hobby.progress, color: Theme.accent)
                    Text("\(Int(hobby.progress * 100))%")
                        .font(.system(size: Theme.FontSize.title3, weight: .bold))
                        .foregroundStyle(Theme.accent)
                        .frame(width: 50, alignment: .trailing)
                }

                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Adjust Progress")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.cardText.opacity(0.6))

                    Slider(value: $sliderValue, in: 0...1, step: 0.05) {
                        Text("Progress")
                    }
                    .tint(Theme.accent)
                    .onChange(of: sliderValue) { newValue in
                        onChanged(newValue)
                    }
                }
            }
            .padding(Theme.Spacing.md)
        }
        .onAppear { sliderValue = hobby.progress }
    }
}

private struct GoalSectionView: View {
    let goal: String

    var body: some View {
        CardView {
            HStack(alignment: .top, spacing: Theme.Spacing.md) {
                Image(systemName: "target")
                    .font(.title2)
                    .foregroundStyle(Theme.accent)

                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("My Goal")
                        .font(.system(size: Theme.FontSize.body, weight: .bold))
                        .foregroundStyle(Theme.cardText)

                    Text(goal)
                        .font(.system(size: Theme.FontSize.body))
                        .foregroundStyle(Theme.cardText.opacity(0.7))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(Theme.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct MilestonesSectionView: View {
    let hobby: Hobby
    @Binding var showAddMilestone: Bool
    @Binding var newMilestoneTitle: String
    let onToggle: (Hobby.Milestone) -> Void
    let onAdd: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                SectionHeaderView(title: "Milestones", systemImage: "checkmark.seal.fill")
                Spacer()
                Button {
                    showAddMilestone.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(Theme.accent)
                        .font(.title2)
                }
            }

            if showAddMilestone {
                CardView {
                    HStack(spacing: Theme.Spacing.sm) {
                        TextField("Milestone title...", text: $newMilestoneTitle)
                            .font(.system(size: Theme.FontSize.body))
                            .foregroundStyle(Theme.cardText)

                        Button("Add") {
                            let trimmed = newMilestoneTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmed.isEmpty else { return }
                            onAdd(trimmed)
                            newMilestoneTitle = ""
                            showAddMilestone = false
                        }
                        .font(.system(size: Theme.FontSize.body, weight: .semibold))
                        .foregroundStyle(Theme.accent)
                        .disabled(newMilestoneTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(Theme.Spacing.md)
                }
            }

            if hobby.milestones.isEmpty && !showAddMilestone {
                EmptyStateCardView(emoji: "🏁", message: "No milestones yet. Add some to track your progress!")
            } else {
                ForEach(hobby.milestones) { milestone in
                    CardView {
                        HStack(spacing: Theme.Spacing.md) {
                            Button {
                                onToggle(milestone)
                            } label: {
                                Image(systemName: milestone.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.title2)
                                    .foregroundStyle(milestone.isCompleted ? .green : Theme.cardText.opacity(0.4))
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(milestone.title)
                                    .font(.system(size: Theme.FontSize.body, weight: .medium))
                                    .foregroundStyle(milestone.isCompleted ? Theme.cardText.opacity(0.4) : Theme.cardText)
                                    .lineLimit(2)

                                if milestone.isCompleted, let date = milestone.dateCompleted {
                                    Text("Completed \(date.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.green.opacity(0.7))
                                }
                            }

                            Spacer()
                        }
                        .padding(Theme.Spacing.md)
                    }
                }
            }
        }
    }
}

// MARK: - Add Hobby Sheet

struct AddHobbyView: View {
    @EnvironmentObject private var viewModel: HobbyTrackerViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var description = ""
    @State private var emoji = "⭐"
    @State private var goalDescription = ""
    @State private var showEmojiPicker = false

    private let emojiOptions = ["⭐", "🎨", "📚", "🎵", "🏃", "🧘", "🍳", "✍️", "🎮", "📷", "🌿", "🎭", "🏋️", "🚴", "🎯", "🧩", "🎸", "🖼️", "🏊", "🤝"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.Spacing.lg) {
                    VStack(spacing: Theme.Spacing.sm) {
                        Button {
                            showEmojiPicker.toggle()
                        } label: {
                            Text(emoji)
                                .font(.system(size: 56))
                                .frame(width: 90, height: 90)
                                .background(Theme.navy.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))
                        }
                        Text("Tap to choose emoji")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, Theme.Spacing.md)

                    if showEmojiPicker {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: Theme.Spacing.sm) {
                            ForEach(emojiOptions, id: \.self) { option in
                                Button {
                                    emoji = option
                                    showEmojiPicker = false
                                } label: {
                                    Text(option)
                                        .font(.title)
                                        .frame(width: 52, height: 52)
                                        .background(emoji == option ? Theme.accent.opacity(0.15) : Color.clear)
                                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                                                .stroke(emoji == option ? Theme.accent : Color.clear, lineWidth: 2)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                    }

                    VStack(spacing: Theme.Spacing.md) {
                        FormFieldView(label: "Hobby Name *", placeholder: "e.g. Watercolor Painting", text: $name)

                        FormFieldView(label: "Description", placeholder: "What do you love about this hobby?", text: $description, isMultiline: true)

                        FormFieldView(label: "Goal", placeholder: "e.g. Complete 10 paintings by year end", text: $goalDescription)
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                }
                .padding(.bottom, Theme.Spacing.xxl)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("New Hobby")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        let hobby = Hobby(
                            name: trimmed,
                            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                            emoji: emoji,
                            goalDescription: goalDescription.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        viewModel.add(hobby)
                        dismiss()
                    }
                    .font(.system(size: Theme.FontSize.body, weight: .semibold))
                    .foregroundStyle(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : Theme.accent)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Edit Hobby Sheet

struct EditHobbyView: View {
    @EnvironmentObject private var viewModel: HobbyTrackerViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var description: String
    @State private var emoji: String
    @State private var goalDescription: String

    private let hobby: Hobby
    private let emojiOptions = ["⭐", "🎨", "📚", "🎵", "🏃", "🧘", "🍳", "✍️", "🎮", "📷", "🌿", "🎭", "🏋️", "🚴", "🎯", "🧩", "🎸", "🖼️", "🏊", "🤝"]

    init(hobby: Hobby) {
        self.hobby = hobby
        _name = State(initialValue: hobby.name)
        _description = State(initialValue: hobby.description)
        _emoji = State(initialValue: hobby.emoji)
        _goalDescription = State(initialValue: hobby.goalDescription)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.Spacing.lg) {
                    Text(emoji)
                        .font(.system(size: 56))
                        .frame(width: 90, height: 90)
                        .background(Theme.navy.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))
                        .padding(.top, Theme.Spacing.md)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: Theme.Spacing.sm) {
                        ForEach(emojiOptions, id: \.self) { option in
                            Button {
                                emoji = option
                            } label: {
                                Text(option)
                                    .font(.title)
                                    .frame(width: 52, height: 52)
                                    .background(emoji == option ? Theme.accent.opacity(0.15) : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.Radius.sm)
                                            .stroke(emoji == option ? Theme.accent : Color.clear, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)

                    VStack(spacing: Theme.Spacing.md) {
                        FormFieldView(label: "Hobby Name *", placeholder: "e.g. Watercolor Painting", text: $name)
                        FormFieldView(label: "Description", placeholder: "What do you love about this hobby?", text: $description, isMultiline: true)
                        FormFieldView(label: "Goal", placeholder: "e.g. Complete 10 paintings by year end", text: $goalDescription)
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                }
                .padding(.bottom, Theme.Spacing.xxl)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Edit Hobby")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        var updated = hobby
                        updated.name = trimmed
                        updated.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
                        updated.emoji = emoji
                        updated.goalDescription = goalDescription.trimmingCharacters(in: .whitespacesAndNewlines)
                        viewModel.update(updated)
                        dismiss()
                    }
                    .font(.system(size: Theme.FontSize.body, weight: .semibold))
                    .foregroundStyle(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : Theme.accent)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Form Field

struct FormFieldView: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isMultiline: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)

            if isMultiline {
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .font(.system(size: Theme.FontSize.body))
                            .foregroundStyle(Color(.placeholderText))
                            .padding(.top, 8)
                            .padding(.leading, 4)
                    }
                    TextEditor(text: $text)
                        .font(.system(size: Theme.FontSize.body))
                        .frame(minHeight: 80)
                }
                .padding(Theme.Spacing.sm)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: Theme.FontSize.body))
                    .padding(Theme.Spacing.sm)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            }
        }
    }
}

#Preview {
    HobbyTrackerView()
        .environmentObject(HobbyTrackerViewModel())
}
