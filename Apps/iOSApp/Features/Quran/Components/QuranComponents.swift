//
//  QuranComponents.swift
//  Hira
//

import SwiftUI

// MARK: - Progress Pie Card
public struct ProgressPieCard: View {
    let progress: Double
    let title: String
    let icon: String
    var isLarge: Bool = false
    @Environment(\.appEnvironment) private var appEnv
    
    public var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.1), lineWidth: isLarge ? 12 : 8)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(LinearGradient(colors: [Color(appEnv.theme.current.primary), Color(appEnv.theme.current.accent)], startPoint: .top, endPoint: .bottom), style: StrokeStyle(lineWidth: isLarge ? 12 : 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 0) {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: isLarge ? 34 : 20, weight: .bold))
                    Text(appEnv.language.localizedString("quran_goal_title"))
                        .font(.system(size: isLarge ? 14 : 10, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: isLarge ? 150 : 80, height: isLarge ? 150 : 80)
            
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(Color(appEnv.theme.current.primary))
                Text(title)
                    .font(.caption.bold())
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .frame(maxWidth: isLarge ? .infinity : 150)
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(16)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(format: appEnv.language.localizedString("quran_accessibility_progress_pie"), "\(Int(progress * 100))"))
    }
}

// MARK: - Last Reading Card
public struct LastReadingCard: View {
    let surah: Surah
    let progress: Double
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(appEnv.language.localizedString("quran_last_reading"))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(colors.primary)
                    .kerning(1)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(surah.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(colors.foreground)
                    Text(String(format: appEnv.language.localizedString("quran_ayah_count_label"), Int(Double(surah.versesCount) * progress), surah.versesCount))
                        .font(.system(size: 14))
                        .foregroundColor(colors.foreground.opacity(0.5))
                }
            }
            
            Spacer()
            
            // Integrated Pie Chart
            ZStack {
                Circle()
                    .stroke(colors.foreground.opacity(0.05), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(colors.primary, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(colors.foreground)
            }
            .frame(width: 70, height: 70)
        }
        .padding(24)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(colors.background))
        .shadow(color: colors.foreground.opacity(0.03), radius: 15, x: 0, y: 10)
        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(colors.foreground.opacity(0.05), lineWidth: 1))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(appEnv.language.localizedString("quran_last_reading")), \(surah.name)")
    }
}

// MARK: - Section Header
public struct SectionHeaderView: View {
    let title: String
    let icon: String
    var onViewAll: (() -> Void)?
    @Environment(\.appEnvironment) private var appEnv
    
    public var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                Text(title)
                    .font(.system(size: 20, weight: .bold))
            }
            Spacer()
            Button(action: { onViewAll?() }) {
                HStack(spacing: 4) {
                    Text(appEnv.language.localizedString("home_articles_all"))
                        .font(.system(size: 14, weight: .medium))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Story Card View
public struct StoryCardView: View {
    let story: QuranStory
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack(alignment: .topTrailing) {
                // Large Image Placeholder matching Articles
                RoundedRectangle(cornerRadius: 20)
                    .fill(colors.primary.opacity(0.1))
                    .frame(height: 160)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundColor(colors.primary.opacity(0.3))
                    )
                
                // Bookmark Icon
                Button(action: {}) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 14, weight: .bold))
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .padding(12)
                }
                .foregroundColor(colors.foreground)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(story.title)
                    .font(.subheadline.bold())
                    .foregroundColor(colors.foreground)
                    .lineLimit(1)
                
                Text(story.description)
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.6))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 260)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(colors.background))
        .shadow(color: colors.foreground.opacity(0.03), radius: 15, x: 0, y: 10)
        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(colors.foreground.opacity(0.05), lineWidth: 1))
    }
}

// MARK: - Topic Card View
public struct TopicCardView: View {
    let topic: QuranTopic
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        HStack(spacing: 12) {
            // Small Story Image matching Article style
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "photo")
                    .font(.caption)
                    .foregroundColor(colors.primary.opacity(0.3))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(colors.foreground)
                    .lineLimit(1)
                
                Text(String(format: appEnv.language.localizedString("quran_topic_stories_count"), topic.storyCount))
                    .font(.system(size: 10, weight: .bold))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(colors.primary.opacity(0.1))
                    .cornerRadius(12)
                    .foregroundColor(colors.primary)
            }
            Spacer()
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(colors.background))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(colors.foreground.opacity(0.05), lineWidth: 1))
    }
}

// MARK: - Daily Ayah Card
public struct DailyAyahCard: View {
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(appEnv.language.localizedString("quran_daily_title"))
                        .font(.caption.bold())
                        .foregroundColor(colors.primary)
                        .kerning(1)
                    Text(appEnv.language.localizedString("quran_daily_ayah_ref"))
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                }
                Spacer()
                Image(systemName: "sun.max.fill")
                    .font(.title2)
                    .foregroundColor(.orange)
            }
            
            Text(appEnv.language.localizedString("quran_daily_ayah_content"))
                .font(.system(size: 18, weight: .medium, design: .serif))
                .multilineTextAlignment(.center)
                .italic()
                .foregroundColor(colors.foreground)
                .padding(.vertical, 8)
            
            HStack {
                Button(action: {}) {
                    Label(appEnv.language.localizedString("quran_daily_button_share"), systemImage: "square.and.arrow.up")
                        .font(.caption.bold())
                }
                Spacer()
                Button(action: {}) {
                    Label(appEnv.language.localizedString("quran_daily_button_read_more"), systemImage: "arrow.right.circle.fill")
                        .font(.caption.bold())
                }
            }
            .foregroundColor(colors.primary)
        }
        .padding(24)
        .background(RoundedRectangle(cornerRadius: 28, style: .continuous).fill(colors.background))
        .shadow(color: colors.foreground.opacity(0.03), radius: 15, x: 0, y: 10)
        .overlay(RoundedRectangle(cornerRadius: 28, style: .continuous).stroke(colors.foreground.opacity(0.05), lineWidth: 1))
    }
}

// MARK: - Juz Components

public struct JuzProgressCard: View {
    let progress: Double
    let stats: String
    let lastRead: String
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        HStack(spacing: 20) {
            // Circular Progress
            ZStack {
                Circle()
                    .stroke(colors.foreground.opacity(0.05), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(colors: [colors.primary, colors.accent], startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(colors.foreground)
            }
            .frame(width: 80, height: 80)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(appEnv.language.localizedString("quran_juz_khatam_title"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(colors.foreground)
                
                Text(stats)
                    .font(.subheadline)
                    .foregroundColor(colors.foreground.opacity(0.6))
                
                Text(lastRead)
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.4))
            }
            Spacer()
        }
        .padding(24)
        .hiraCleanCard(colors: colors, radius: 28)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(format: appEnv.language.localizedString("quran_acc_juz_progress"), stats, lastRead))
    }
}

public struct JuzRowView: View {
    let juz: JuzProgress
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        HStack(spacing: 16) {
            // Juz Number
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 44, height: 44)
                Text("\(juz.number)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(String(format: appEnv.language.localizedString("quran_juz_number"), juz.number))
                    .font(.subheadline.bold())
                    .foregroundColor(colors.foreground)
                Text(juz.surahRange)
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.5))
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text("\(Int(juz.progress * 100))%")
                    .font(.caption.bold())
                    .foregroundColor(colors.foreground.opacity(0.4))
                
                // Mini Progress Bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(colors.foreground.opacity(0.05))
                        Capsule()
                            .fill(colors.primary)
                            .frame(width: geo.size.width * juz.progress)
                    }
                }
                .frame(width: 80, height: 4)
            }
        }
        .padding(16)
        .hiraCleanCard(colors: colors, radius: 24)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(format: appEnv.language.localizedString("quran_acc_juz_row"), "\(juz.number)", juz.surahRange, "\(Int(juz.progress * 100))"))
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Bookmark Components

public struct BookmarkHeaderCard: View {
    let count: Int
    let lastRead: String
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 56, height: 56)
                Image(systemName: "bookmark.fill")
                    .font(.title3)
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(appEnv.language.localizedString("quran_bookmark_header_title"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(colors.foreground)
                
                Text(String(format: appEnv.language.localizedString("quran_bookmark_count"), count))
                    .font(.subheadline)
                    .foregroundColor(colors.foreground.opacity(0.6))
                
                Text(lastRead)
                    .font(.caption)
                    .foregroundColor(colors.foreground.opacity(0.4))
            }
            Spacer()
        }
        .padding(24)
        .hiraCleanCard(colors: colors, radius: 28)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(format: appEnv.language.localizedString("quran_acc_bookmark_header"), String(format: appEnv.language.localizedString("quran_bookmark_count"), count), lastRead))
    }
}

public struct BookmarkRowView: View {
    let bookmark: QuranBookmark
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header Row
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(colors.primary.opacity(0.1))
                        .frame(width: 44, height: 44)
                    Text("\(bookmark.surahNumber)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(colors.primary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(bookmark.surahName)
                        .font(.subheadline.bold())
                    Text(bookmark.surahNameArabic)
                        .font(.caption)
                        .foregroundColor(colors.primary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: appEnv.language.localizedString("quran_ayah_ref"), bookmark.ayahNumber))
                        .font(.subheadline.bold())
                    Text(String(format: appEnv.language.localizedString("quran_time_ago"), bookmark.timeAgo))
                        .font(.system(size: 10))
                        .foregroundColor(colors.foreground.opacity(0.4))
                }
                
                Image(systemName: "bookmark.fill")
                    .foregroundColor(colors.primary)
                    .font(.caption)
                    .padding(8)
                    .background(colors.primary.opacity(0.1))
                    .clipShape(Circle())
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // Ayah Text Box
            VStack {
                Text(bookmark.arabicText)
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .multilineTextAlignment(.trailing)
                    .lineSpacing(8)
                    .foregroundColor(colors.foreground)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(20)
            .background(colors.foreground.opacity(0.03))
            .cornerRadius(16)
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .hiraCleanCard(colors: colors, radius: 26)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(format: appEnv.language.localizedString("quran_acc_bookmark_row"), bookmark.surahName, "\(bookmark.ayahNumber)", bookmark.timeAgo, bookmark.arabicText))
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Daily Components

public struct DailyReminderCard: View {
    let reminder: DailyReminder
    @Environment(\.appEnvironment) private var appEnv
    
    private var colors: ThemeModel { appEnv.theme.current }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Image Section
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(colors.primary.opacity(0.1))
                    .frame(height: 200)
                    .overlay(
                        // Simulated high-fidelity image background
                        LinearGradient(colors: [colors.primary.opacity(0.2), colors.accent.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                
                // We'll use the placeholder image if available, or just a beautiful gradient
                if !reminder.image.isEmpty {
                    // This would normally be an Image(reminder.image)
                    Image(systemName: "sparkles")
                        .font(.largeTitle)
                        .foregroundColor(colors.primary.opacity(0.3))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            VStack(alignment: .leading, spacing: 12) {
                Text(reminder.title)
                    .font(.title3.bold())
                    .foregroundColor(colors.foreground)
                
                Text(reminder.description)
                    .font(.subheadline)
                    .foregroundColor(colors.foreground.opacity(0.7))
                    .lineSpacing(4)
                
                Text("- \(reminder.reference)")
                    .font(.caption.bold())
                    .foregroundColor(colors.primary)
                
                Text(reminder.arabicText)
                    .font(.system(size: 20, weight: .medium, design: .serif))
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(colors.foreground)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.top, 8)
                
                HStack(spacing: 24) {
                    Text(reminder.time)
                        .font(.caption.bold())
                        .foregroundColor(colors.foreground.opacity(0.4))
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        InteractionButton(icon: "heart", count: reminder.likes)
                        InteractionButton(icon: "bookmark", count: reminder.bookmarks)
                        InteractionButton(icon: "arrowshape.turn.up.right", count: reminder.shares)
                    }
                }
                .padding(.top, 12)
            }
            .padding(.horizontal, 4)
        }
        .padding(16)
        .hiraCleanCard(colors: colors, radius: 30)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(format: appEnv.language.localizedString("quran_acc_daily_reminder"), reminder.title, reminder.reference, reminder.arabicText))
        .accessibilityAddTraits(.isButton)
    }
}

private struct InteractionButton: View {
    let icon: String
    let count: Int
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
            Text("\(count)")
                .font(.system(size: 12, weight: .bold))
        }
        .foregroundColor(appEnv.theme.current.foreground.opacity(0.6))
        .accessibilityLabel(String(format: appEnv.language.localizedString("quran_acc_interaction"), count, appEnv.language.localizedString("quran_acc_\(icon)s")))
    }
}
