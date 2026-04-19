//
//  QuranHistoryView.swift
//  Hira
//
//  Created by Ryuk on 09/04/26.
//

import SwiftUI

struct QuranHistoryView: View {
    @Bindable var viewModel: QuranViewModel
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss

    private var colors: ThemeModel { appEnv.theme.current }

    // MARK: - Monthly Stats

    private var totalSeconds: Int  { viewModel.activityDays.reduce(0)    { $0 + $1.secondsRead } }
    private var totalVerses: Int   { viewModel.activityDays.reduce(0)    { $0 + $1.versesRead } }
    private var totalPages: Double { viewModel.activityDays.reduce(0.0)  { $0 + $1.pagesRead } }
    private var activeDays: Int    { viewModel.activityDays.filter { $0.secondsRead > 0 }.count }

    private var formattedTotalTime: String {
        let minutes = totalSeconds / 60
        if minutes >= 60 { let h = minutes / 60; let m = minutes % 60; return m > 0 ? "\(h)h \(m)m" : "\(h)h" }
        return "\(minutes)m"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        if viewModel.isFetchingActivityDays && viewModel.activityDays.isEmpty {
                            loadingState
                        } else if viewModel.activityDays.isEmpty {
                            emptyState
                        } else {
                            monthlySummaryCard.padding(.horizontal, 24)
                            activityDaysList
                        }
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Reading History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(colors.primary)
                }
            }
            .onAppear { viewModel.fetchActivityDays() }
        }
    }

    // MARK: - Monthly Summary Card

    private var monthlySummaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Last 30 Days")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(colors.primary)

            HStack(spacing: 0) {
                statPill(icon: "clock.fill",              value: formattedTotalTime,                  label: "Reading Time")
                Divider().frame(height: 36).padding(.horizontal, 8)
                statPill(icon: "text.alignleft",          value: "\(totalVerses)",                    label: "Ayahs Read")
                Divider().frame(height: 36).padding(.horizontal, 8)
                statPill(icon: "doc.text.fill",           value: String(format: "%.1f", totalPages),  label: "Pages")
                Divider().frame(height: 36).padding(.horizontal, 8)
                statPill(icon: "calendar.badge.checkmark", value: "\(activeDays)",                   label: "Active Days")
            }

            activityStrip
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(colors.foreground.opacity(0.03)))
        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(colors.foreground.opacity(0.06), lineWidth: 1))
    }

    private func statPill(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 12)).foregroundColor(colors.primary)
            Text(value).font(.system(size: 15, weight: .bold, design: .rounded)).foregroundColor(colors.foreground)
            Text(label).font(.system(size: 9, weight: .medium)).foregroundColor(colors.foreground.opacity(0.4)).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    /// 30-day heat-map strip.
    /// Cells are coloured with a gradient: no activity = white/clear, max activity = deep green.
    private var activityStrip: some View {
        let calendar = Calendar.current
        let today = Date()
        let days: [Date] = (0..<30).compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }.reversed()

        let dateMap: [String: ActivityDayEntity] = Dictionary(
            uniqueKeysWithValues: viewModel.activityDays.map { ($0.date, $0) }
        )
        let maxSeconds = viewModel.activityDays.map(\.secondsRead).max() ?? 1

        // Colour ramp: white (0) → deep green (1)
        let emptyColor  = Color.white.opacity(0.25)
        let activeColor = Color(red: 0.05, green: 0.55, blue: 0.25)   // rich forest green

        return HStack(spacing: 3) {
            ForEach(Array(days.enumerated()), id: \.element) { idx, date in
                let key = localKey(date)
                let intensity = dateMap[key].map { Double($0.secondsRead) / Double(max(1, maxSeconds)) } ?? 0.0
                let cellColor = intensity < 0.01
                    ? emptyColor
                    : emptyColor.mix(with: activeColor, by: intensity)

                RoundedRectangle(cornerRadius: 3)
                    .fill(cellColor)
                    .frame(height: 22)
                    .frame(maxWidth: .infinity)
                    .overlay {
                        if calendar.isDateInToday(date) {
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(activeColor, lineWidth: 1.5)
                        }
                    }
            }
        }
    }

    // MARK: - Activity Days List

    private var activityDaysList: some View {
        let grouped = Dictionary(grouping: viewModel.activityDays) { day -> String in
            if Calendar.current.isDateInToday(day.parsedDate)     { return "__today__" }
            if Calendar.current.isDateInYesterday(day.parsedDate) { return "__yesterday__" }
            return day.date
        }
        let sortedKeys = grouped.keys.sorted {
            if $0 == "__today__"     { return true }
            if $1 == "__today__"     { return false }
            if $0 == "__yesterday__" { return true }
            if $1 == "__yesterday__" { return false }
            return $0 > $1
        }

        return LazyVStack(alignment: .leading, spacing: 20) {
            ForEach(sortedKeys, id: \.self) { key in
                VStack(alignment: .leading, spacing: 10) {
                    Text(sectionTitle(for: key))
                        .font(.headline.bold())
                        .foregroundColor(colors.primary)
                        .padding(.horizontal, 24)
                    ForEach(grouped[key] ?? []) { day in
                        ActivityDayRow(day: day, surahs: viewModel.surahs)
                    }
                }
            }
        }
    }

    // MARK: - Empty / Loading

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 80)
            Image(systemName: "calendar.badge.clock").font(.system(size: 64)).foregroundColor(colors.primary.opacity(0.18))
            Text("No reading history yet").font(.title3.bold()).foregroundColor(colors.foreground)
            Text("Your daily reading activity will appear here once you begin reading your first Surah.")
                .font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
    }

    private var loadingState: some View {
        VStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 24).fill(Color.secondary.opacity(0.05)).frame(height: 140).padding(.horizontal, 24)
            ForEach(0..<4, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 20).fill(Color.secondary.opacity(0.04)).frame(height: 100).padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Helpers

    private func sectionTitle(for key: String) -> String {
        if key == "__today__"     { return "Today" }
        if key == "__yesterday__" { return "Yesterday" }
        let fmt = DateFormatter(); fmt.dateFormat = "yyyy-MM-dd"; fmt.timeZone = TimeZone.current
        if let date = fmt.date(from: key) {
            let d = DateFormatter(); d.dateStyle = .long; return d.string(from: date)
        }
        return key
    }

    private func localKey(_ date: Date) -> String {
        let fmt = DateFormatter(); fmt.dateFormat = "yyyy-MM-dd"; fmt.timeZone = TimeZone.current
        return fmt.string(from: date)
    }
}

// MARK: - Color Mixing Helper

private extension Color {
    /// Linear interpolation between self and another color.
    func mix(with other: Color, by amount: Double) -> Color {
        let t = max(0, min(1, amount))
        return Color(
            red:   lerp(component(\.red),   other.component(\.red),   t),
            green: lerp(component(\.green), other.component(\.green), t),
            blue:  lerp(component(\.blue),  other.component(\.blue),  t),
            opacity: lerp(component(\.opacity), other.component(\.opacity), t)
        )
    }

    private func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double { a + (b - a) * t }

    private func component(_ keyPath: KeyPath<(red: Double, green: Double, blue: Double, opacity: Double), Double>) -> Double {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        let tuple = (red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
        return tuple[keyPath: keyPath]
    }
}

// MARK: - Activity Day Row

private struct ActivityDayRow: View {
    let day: ActivityDayEntity
    let surahs: [Surah]

    @Environment(\.appEnvironment) private var appEnv
    @State private var expanded = false
    private var colors: ThemeModel { appEnv.theme.current }

    private var minutesRead: Int { day.secondsRead / 60 }
    private var formattedTime: String {
        guard minutesRead > 0 else { return "\(day.secondsRead)s" }
        if minutesRead >= 60 { let h = minutesRead / 60; let m = minutesRead % 60; return m > 0 ? "\(h)h \(m)m" : "\(h)h" }
        return "\(minutesRead)m"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Main row
            HStack(spacing: 14) {
                // Date badge
                VStack(spacing: 1) {
                    Text(dayNumber)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.05, green: 0.55, blue: 0.25))
                    Text(monthAbbr)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(colors.foreground.opacity(0.38))
                }
                .frame(width: 40, height: 50)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(red: 0.05, green: 0.55, blue: 0.25).opacity(0.10)))

                VStack(alignment: .leading, spacing: 5) {
                    Text(headlineText)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(colors.foreground)
                        .lineLimit(1)

                    HStack(spacing: 8) {
                        statChip(icon: "clock",        text: formattedTime)
                        statChip(icon: "text.alignleft", text: "\(day.versesRead) ayah")
                        if day.pagesRead > 0 {
                            statChip(icon: "doc.text", text: String(format: "%.1f pg", day.pagesRead))
                        }
                    }

                    if day.dailyTargetSeconds > 0 {
                        let ratio = min(Double(day.secondsRead) / Double(day.dailyTargetSeconds), 1.0)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(colors.foreground.opacity(0.06))
                                Capsule()
                                    .fill(LinearGradient(
                                        colors: [Color(red: 0.05, green: 0.55, blue: 0.25).opacity(0.7),
                                                 Color(red: 0.05, green: 0.55, blue: 0.25)],
                                        startPoint: .leading, endPoint: .trailing
                                    ))
                                    .frame(width: geo.size.width * ratio)
                            }
                        }
                        .frame(height: 4)
                    }
                }

                Spacer(minLength: 4)

                VStack(alignment: .trailing, spacing: 6) {
                    if day.progress > 0 {
                        Text("\(Int(day.progress * 100))%")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.05, green: 0.55, blue: 0.25))
                    }
                    if !day.ranges.isEmpty {
                        Button {
                            withAnimation(.easeInOut(duration: 0.22)) { expanded.toggle() }
                        } label: {
                            Image(systemName: expanded ? "chevron.up" : "chevron.down")
                                .font(.caption.bold())
                                .foregroundColor(colors.foreground.opacity(0.3))
                        }
                    }
                }
            }
            .padding(14)

            // Expanded ranges — resolved to surah names + ayah numbers
            if expanded && !day.ranges.isEmpty {
                Divider().padding(.horizontal, 14)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Ayah Ranges")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(colors.foreground.opacity(0.35))
                        .padding(.bottom, 2)

                    ForEach(Array(day.ranges.enumerated()), id: \.offset) { _, range in
                        resolvedRangeRow(range)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
            }
        }
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(colors.foreground.opacity(0.03)))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(colors.foreground.opacity(0.06), lineWidth: 1))
        .padding(.horizontal, 24)
    }

    /// Parses "startSurah:startAyah-endSurah:endAyah" and renders it with surah names.
    @ViewBuilder
    private func resolvedRangeRow(_ rangeStr: String) -> some View {
        if let parsed = parseRange(rangeStr) {
            HStack(alignment: .top, spacing: 8) {
                // Green dot
                Circle()
                    .fill(Color(red: 0.05, green: 0.55, blue: 0.25).opacity(0.6))
                    .frame(width: 6, height: 6)
                    .padding(.top, 4)

                VStack(alignment: .leading, spacing: 2) {
                    if parsed.startSurah == parsed.endSurah {
                        // Same surah
                        let name = surahName(parsed.startSurah)
                        Text(name)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(colors.foreground)
                        Text("Ayah \(parsed.startAyah) – \(parsed.endAyah)")
                            .font(.system(size: 11))
                            .foregroundColor(colors.foreground.opacity(0.5))
                    } else {
                        // Cross-surah range
                        let s1 = surahName(parsed.startSurah)
                        let s2 = surahName(parsed.endSurah)
                        Text("\(s1) · Ayah \(parsed.startAyah)")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(colors.foreground)
                        Text("→ \(s2) · Ayah \(parsed.endAyah)")
                            .font(.system(size: 11))
                            .foregroundColor(colors.foreground.opacity(0.5))
                    }
                }
            }
        } else {
            // Fallback raw string
            HStack(spacing: 8) {
                Circle().fill(Color.secondary.opacity(0.4)).frame(width: 6, height: 6)
                Text(rangeStr).font(.system(size: 12, design: .monospaced)).foregroundColor(colors.foreground.opacity(0.5))
            }
        }
    }

    // MARK: - Range Parsing & Surah Lookup

    private struct ParsedRange {
        let startSurah: Int
        let startAyah: Int
        let endSurah: Int
        let endAyah: Int
    }

    /// Parses "startSurah:startAyah-endSurah:endAyah" or "surah:startAyah-endAyah".
    private func parseRange(_ raw: String) -> ParsedRange? {
        let sides = raw.components(separatedBy: "-")
        guard sides.count == 2 else { return nil }

        let startParts = sides[0].components(separatedBy: ":")
        let endParts   = sides[1].components(separatedBy: ":")

        guard startParts.count == 2,
              let ss = Int(startParts[0]),
              let sa = Int(startParts[1]) else { return nil }

        if endParts.count == 2, let es = Int(endParts[0]), let ea = Int(endParts[1]) {
            return ParsedRange(startSurah: ss, startAyah: sa, endSurah: es, endAyah: ea)
        }
        // "surah:start-end" short form (same surah)
        if let ea = Int(sides[1]) {
            return ParsedRange(startSurah: ss, startAyah: sa, endSurah: ss, endAyah: ea)
        }
        return nil
    }

    private func surahName(_ number: Int) -> String {
        surahs.first(where: { $0.number == number })?.name ?? "Surah \(number)"
    }

    private func statChip(icon: String, text: String) -> some View {
        HStack(spacing: 3) {
            Image(systemName: icon).font(.system(size: 9))
            Text(text).font(.system(size: 11, weight: .medium))
        }
        .foregroundColor(colors.foreground.opacity(0.45))
        .padding(.horizontal, 7).padding(.vertical, 3)
        .background(Capsule().fill(colors.foreground.opacity(0.06)))
    }

    private var headlineText: String {
        guard !day.ranges.isEmpty else { return "Activity recorded" }
        if let p = parseRange(day.ranges.first ?? "") {
            let name = surahName(p.startSurah)
            if day.ranges.count == 1 {
                return "\(name) · Ayah \(p.startAyah)–\(p.endAyah)"
            }
            return "\(name) + \(day.ranges.count - 1) more range\(day.ranges.count > 2 ? "s" : "")"
        }
        return "\(day.ranges.count) ranges"
    }

    private var dayNumber: String  { formatted("d") }
    private var monthAbbr: String  { formatted("MMM").uppercased() }

    private func formatted(_ fmt: String) -> String {
        let f = DateFormatter(); f.dateFormat = fmt; f.timeZone = TimeZone.current
        return f.string(from: day.parsedDate)
    }
}

#Preview {
    QuranHistoryView(viewModel: QuranViewModel())
        .environment(\.appEnvironment, AppEnvironment(
            theme: ThemeManager(), security: SecurityManager(),
            language: LanguageManager(), di: DIContainer.shared
        ))
}
