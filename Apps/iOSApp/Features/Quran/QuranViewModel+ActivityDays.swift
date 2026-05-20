//
//  QuranViewModel+ActivityDays.swift
//  Hira
//
//  Created by Ryuk on 17/04/26.
//

import Foundation
import Combine

extension QuranViewModel {

    // MARK: - Fetch Activity Days

    /// Fetches the last 30 days of QURAN activity to power the history view and Juz progress.
    public func fetchActivityDays(from: String? = nil, to: String? = nil) {
        guard !isFetchingActivityDays else { return }

        // Use local timezone so "today" correctly matches the user's calendar day
        let toDate   = to   ?? localDateString(from: Date())
        let fromDate = from ?? localDateString(from: Calendar.current.date(byAdding: .day, value: -29, to: Date()) ?? Date())

        isFetchingActivityDays = true
        print("📅 ActivityDays: Fetching from \(fromDate) to \(toDate)")

        getActivityDaysUseCase.execute(from: fromDate, to: toDate, type: "QURAN", first: 20)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isFetchingActivityDays = false
                if case .failure(let error) = completion {
                    print("❌ ActivityDays: Fetch error: \(error)")
                }
            } receiveValue: { [weak self] (entities, _) in
                guard let self = self else { return }
                self.activityDays = entities.sorted { $0.date > $1.date }
                self.syncHistoryFromActivityDays()
                print("✅ ActivityDays: Fetched \(entities.count) days")
            }
            .store(in: &cancellables)
    }

    // MARK: - Activity Day Tracking

    /// Starts tracking immediately when the user enters a reading view.
    public func startActivityDayTracking() {
        stopActivityDayTracking()

        activityDaySessionStart = Date()
        activityDayElapsedSeconds = 0
        activityDayReadRanges = []
        activityDayCurrentAyah = nil

        activityDayTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.activityDayElapsedSeconds += 1
        }

        print("📅 ActivityDays: Tracking started")
    }

    /// Stops tracking and flushes a final POST with all accumulated data.
    public func stopActivityDayTracking() {
        activityDayTimer?.invalidate()
        activityDayTimer = nil

        if activityDayElapsedSeconds > 0, !activityDayReadRanges.isEmpty {
            // Capture before reset, then flush
            triggerActivityDayPost(thenFetch: true)
        }

        activityDaySessionStart = nil
        activityDayElapsedSeconds = 0
        activityDayReadRanges = []
        activityDayCurrentAyah = nil
        print("📅 ActivityDays: Tracking stopped")
    }

    /// Called on every ayah change. Accumulates the range and POSTs an incremental update.
    public func updateActivityDay(ayah: QuranAyah) {
        let current = (surah: ayah.surahNumber, ayah: ayah.number)

        // Skip if this is the same ayah as before
        if let prev = activityDayCurrentAyah,
           prev.surah == current.surah,
           prev.ayah  == current.ayah { return }

        activityDayCurrentAyah = current

        // Range format: "surah:startAyah-surah:endAyah"  e.g. "1:7-1:7"
        let rangeKey = "\(current.surah):\(current.ayah)-\(current.surah):\(current.ayah)"
        if !activityDayReadRanges.contains(rangeKey) {
            activityDayReadRanges.append(rangeKey)
        }

        // POST once at least 5 seconds have elapsed in this session
        if activityDayElapsedSeconds >= 5 {
            triggerActivityDayPost(thenFetch: false)
        }
    }

    /// Posts the current accumulated data to the API.
    /// - Parameter thenFetch: When true (used on stop), refreshes the activity list after a successful POST.
    public func triggerActivityDayPost(thenFetch: Bool = false) {
        let seconds = activityDayElapsedSeconds
        let ranges  = activityDayReadRanges

        guard seconds > 0, !ranges.isEmpty else { return }

        let date     = localDateString(from: Date())
        let timezone = TimeZone.current.identifier

        print("📅 ActivityDays: Posting \(seconds)s | ranges: \(ranges)")

        // Reset elapsed so the NEXT post only counts NEW seconds on top
        activityDayElapsedSeconds = 0

        addActivityDayUseCase.execute(
            type: "QURAN",
            seconds: seconds,
            ranges: ranges,
            mushafId: 4,
            date: date,
            timezone: timezone
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case .failure(let error) = completion {
                print("❌ ActivityDays: Post error: \(error)")
            }
        } receiveValue: { [weak self] in
            print("✅ ActivityDays: Posted successfully")
            if thenFetch {
                self?.fetchActivityDays()
            }
        }
        .store(in: &cancellables)
    }

    // MARK: - Sync History Items

    /// Maps ActivityDayEntity → QuranHistoryItem using the first range's surah/ayah.
    private func syncHistoryFromActivityDays() {
        let items: [QuranHistoryItem] = activityDays.compactMap { day in
            guard let firstRange = day.ranges.first, !firstRange.isEmpty else { return nil }
            let parts = firstRange.components(separatedBy: ":")
            guard parts.count >= 2,
                  let surahNumber = Int(parts[0]),
                  let ayahPart = parts[1].components(separatedBy: "-").first,
                  let ayahNumber = Int(ayahPart) else { return nil }

            let surah = surahs.first(where: { $0.number == surahNumber })
            return QuranHistoryItem(
                surahNumber: surahNumber,
                surahName: surah?.name ?? "Surah \(surahNumber)",
                surahNameArabic: surah?.nameArabic ?? "",
                ayahNumber: ayahNumber,
                date: day.parsedDate
            )
        }
        history = items
    }

    // MARK: - Juz Progress

    /// Computes a per-Juz reading ratio from activity day ranges. Returns 0.0–1.0.
    public func activityProgress(for juz: JuzProgress) -> Double {
        guard !activityDays.isEmpty else { return juz.progress }
        let readPairs = allReadPairs()
        guard !readPairs.isEmpty else { return 0 }
        let juzKeys = juzVerseKeys(for: juz)
        guard !juzKeys.isEmpty else { return 0 }
        let readCount = juzKeys.filter { readPairs.contains($0) }.count
        return min(Double(readCount) / Double(juzKeys.count), 1.0)
    }

    /// Overall khatam progress across all Juzs based on activity data.
    public var activityKhatamProgress: Double {
        if activityDays.isEmpty { return khatamProgress }
        return min(Double(allReadPairs().count) / 6236.0, 1.0)
    }

    private func allReadPairs() -> Set<String> {
        var pairs = Set<String>()
        for day in activityDays {
            for range in day.ranges {
                expandRange(range).forEach { pairs.insert($0) }
            }
        }
        return pairs
    }

    // MARK: - Range Expansion

    /// Expands "2:255-2:286" into ["2:255", "2:256", ... "2:286"].
    private func expandRange(_ rangeStr: String) -> [String] {
        // Format: "surah:startAyah-surah:endAyah"
        // Split on "-" but be careful: surah numbers make this "2:255-2:286"
        // Strategy: split on "-" giving ["2:255", "2:286"], then parse each side
        let sides = rangeStr.components(separatedBy: "-")
        guard sides.count == 2 else {
            // Single ayah with no dash – try to parse "surah:ayah"
            let p = rangeStr.components(separatedBy: ":")
            if p.count == 2, let s = Int(p[0]), let a = Int(p[1]) {
                return ["\(s):\(a)"]
            }
            return []
        }

        let startParts = sides[0].components(separatedBy: ":")
        let endParts   = sides[1].components(separatedBy: ":")

        guard startParts.count == 2,
              let startSurah = Int(startParts[0]),
              let startAyah  = Int(startParts[1]),
              endParts.count == 2,
              let endAyah    = Int(endParts[1]) else { return [] }

        return (startAyah...max(startAyah, endAyah)).map { "\(startSurah):\($0)" }
    }

    /// Returns "surah:ayah" keys for all ayahs in a Juz using its verseMapping.
    private func juzVerseKeys(for juz: JuzProgress) -> [String] {
        var keys: [String] = []
        for (surahStr, lastVerseStr) in juz.verseMapping {
            guard let surah = Int(surahStr), let lastVerse = Int(lastVerseStr) else { continue }
            for ayah in 1...max(1, lastVerse) {
                keys.append("\(surah):\(ayah)")
            }
        }
        return keys
    }

    // MARK: - Date Helpers

    /// Returns a YYYY-MM-DD string in the device's local timezone.
    func localDateString(from date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        fmt.timeZone = TimeZone.current
        return fmt.string(from: date)
    }
}
