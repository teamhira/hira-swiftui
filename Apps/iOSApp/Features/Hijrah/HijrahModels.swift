//
//  HijrahModels.swift
//  Hira
//
//  Created by Ryuk on 04/04/26.
//

import Foundation

public enum JourneyType: String, Codable, Hashable, Equatable {
    case mualaf
    case hijrah
    case better
}

public enum MissionType: String, Codable, Hashable, Equatable {
    case simple // Just tap to complete
    case knowledge // Requires reading content
    case tasbih // Requires tasbih count
    case quiz // Requires answering questions
    case video // Requires watching a video
    case audio // Requires listening to audio
    case timer // Requires completing a timed task
}

public struct MissionMedia: Codable, Hashable, Equatable {
    public let url: String
    public let thumbnail: String?
    public let duration: Int? // in seconds
    public let isYoutube: Bool
    
    public init(url: String, thumbnail: String? = nil, duration: Int? = nil, isYoutube: Bool = false) {
        self.url = url
        self.thumbnail = thumbnail
        self.duration = duration
        self.isYoutube = isYoutube
    }
}

public struct MissionTimer: Codable, Hashable, Equatable {
    public let targetSeconds: Int
    public let label: String
    
    public init(targetSeconds: Int, label: String) {
        self.targetSeconds = targetSeconds
        self.label = label
    }
}

public struct QuizOption: Codable, Hashable, Equatable {
    public let id: String
    public let text: String
    public let isCorrect: Bool
    
    public init(id: String = UUID().uuidString, text: String, isCorrect: Bool) {
        self.id = id
        self.text = text
        self.isCorrect = isCorrect
    }
}

public struct MissionQuiz: Codable, Hashable, Equatable {
    public let question: String
    public let options: [QuizOption]
    public let explanation: String?
    
    public init(question: String, options: [QuizOption], explanation: String? = nil) {
        self.question = question
        self.options = options
        self.explanation = explanation
    }
}

public enum ContentBlockType: String, Codable, Hashable, Equatable {
    case heading
    case body
    case arabic
    case translation
    case image
    case highlight
}

public struct ContentBlock: Codable, Hashable, Equatable {
    public let type: ContentBlockType
    public let value: String
    public let extra: String? // for metadata like image alt or sub-captions
    
    public init(type: ContentBlockType, value: String, extra: String? = nil) {
        self.type = type
        self.value = value
        self.extra = extra
    }
}

public struct MissionReference: Codable, Hashable, Equatable {
    public let title: String
    public let icon: String
    public let targetId: String // e.g. surah_id or article_id
    public let type: ReferenceType
    
    public enum ReferenceType: String, Codable, Hashable, Equatable {
        case quran
        case guide
        case community
        case article
    }
    
    public init(title: String, icon: String, targetId: String, type: ReferenceType) {
        self.title = title
        self.icon = icon
        self.targetId = targetId
        self.type = type
    }
}

public struct Mission: Codable, Hashable, Equatable, Identifiable {
    public var id: String { key }
    public let key: String
    public let title: String
    public let description: String
    public let type: MissionType
    public let content: [ContentBlock]? 
    public let references: [MissionReference]? 
    public let quiz: MissionQuiz? 
    public let media: MissionMedia? // For video/audio missions
    public let timer: MissionTimer? // For timed tasks
    public let targetCount: Int? 
    public let expReward: Int
    public var isCompleted: Bool = false
    public var order: Int
    
    public init(
        key: String,
        title: String,
        description: String,
        type: MissionType,
        content: [ContentBlock]? = nil,
        references: [MissionReference]? = nil,
        quiz: MissionQuiz? = nil,
        media: MissionMedia? = nil,
        timer: MissionTimer? = nil,
        targetCount: Int? = nil,
        expReward: Int,
        order: Int,
        isCompleted: Bool = false
    ) {
        self.key = key
        self.title = title
        self.description = description
        self.type = type
        self.content = content
        self.references = references
        self.quiz = quiz
        self.media = media
        self.timer = timer
        self.targetCount = targetCount
        self.expReward = expReward
        self.order = order
        self.isCompleted = isCompleted
    }
}

public struct JourneyState: Codable, Hashable, Equatable {
    public var type: JourneyType
    public var day: Int
    
    // Journey Progress
    public var level: Int
    public var xp: Int
    
    // Global Progress
    public var globalLevel: Int
    public var globalXP: Int
    
    public var streak: Int
    public var completedMissionIds: Set<String>
    public var activeMissionIds: Set<String> // Missions being "followed"
    public var unlockedAchievementIds: Set<Int> // Achievements already earned
    public var completionDates: [String: Date]
    
    public init(
        type: JourneyType,
        day: Int = 1,
        level: Int = 1,
        xp: Int = 0,
        globalLevel: Int = 1,
        globalXP: Int = 0,
        streak: Int = 0,
        completedMissionIds: Set<String> = [],
        activeMissionIds: Set<String> = [],
        unlockedAchievementIds: Set<Int> = [],
        completionDates: [String: Date] = [:]
    ) {
        self.type = type
        self.day = day
        self.level = level
        self.xp = xp
        self.globalLevel = globalLevel
        self.globalXP = globalXP
        self.streak = streak
        self.completedMissionIds = completedMissionIds
        self.activeMissionIds = activeMissionIds
        self.unlockedAchievementIds = unlockedAchievementIds
        self.completionDates = completionDates
    }
}

public struct Achievement: Identifiable, Hashable, Codable {
    public let id: Int
    public let icon: String
    public let title: String
    public let description: String
    public let category: String
    public let xp: Int
    public let types: [JourneyType]
    public let order: Int
    public var isLocked: Bool
    
    public var idValue: Int { id }
    
    public init(id: Int, icon: String, title: String, description: String, category: String, xp: Int, types: [JourneyType], order: Int, isLocked: Bool = true) {
        self.id = id
        self.icon = icon
        self.title = title
        self.description = description
        self.category = category
        self.xp = xp
        self.types = types
        self.order = order
        self.isLocked = isLocked
    }
}

public struct IslamicLevel {
    public let levelRange: ClosedRange<Int>
    public let nameKey: String
    
    public static func getLevelBaseName(for level: Int, type: JourneyType) -> String {
        let normalizedLevel = min(max(level, 1), 100)
        let groupIndex = (normalizedLevel - 1) / 10
        
        switch type {
        case .mualaf:
            let names = ["Mualaf", "Muslim", "Mu'min", "Muhsin", "Muttaqin", "Mukhlas", "Siddiqin", "Shuhada", "Sabiqun", "Assalaf"]
            return names[groupIndex]
        case .hijrah:
            let names = ["Pemula", "Pencari", "Penuntut", "Pekarya", "Pejuang", "Pemenang", "Penerang", "Penyabar", "Penolong", "Pecinta"]
            return names[groupIndex]
        case .better:
            let names = ["Pelajar", "Penyimak", "Pemaham", "Pengamal", "Penjaga", "Penyebar", "Pembangun", "Pembimbing", "Pemimpin", "Pewaris"]
            return names[groupIndex]
        }
    }
    
    public static func getLevelTierInfo(for level: Int) -> (name: String, roman: String, colorHex: String) {
        let subIndex = (level - 1) % 10 // 0-9
        
        // 1-3: Bidayah, 4-6: Wasathiyah, 7-10: Ihsan
        if subIndex < 3 {
            return ("Bidayah", ["I", "II", "III"][subIndex], "#CD7F32") // Bronze-like
        } else if subIndex < 6 {
            return ("Wasathiyah", ["I", "II", "III"][subIndex - 3], "#C0C0C0") // Silver-like
        } else {
            // 7-10 are all Ihsan
            let romanIndex = min(subIndex - 6, 2)
            let roman = ["I", "II", "III"][romanIndex]
            return ("Ihsan", roman, "#FFD700") // Gold-like
        }
    }
}

public struct SuggestionModule: Codable, Hashable, Equatable {
    public let title: String
    public let description: String?
    public let content: [ContentBlock]
    
    public init(title: String, description: String? = nil, content: [ContentBlock]) {
        self.title = title
        self.description = description
        self.content = content
    }
}

public struct Suggestion: Codable, Hashable, Equatable, Identifiable {
    public var id: String { key }
    public let key: String
    public let title: String
    public let description: String
    public let icon: String
    public let targetJourneys: [JourneyType]
    public let modules: [SuggestionModule]
    
    public init(
        key: String,
        title: String,
        description: String,
        icon: String,
        targetJourneys: [JourneyType],
        modules: [SuggestionModule]
    ) {
        self.key = key
        self.title = title
        self.description = description
        self.icon = icon
        self.targetJourneys = targetJourneys
        self.modules = modules
    }
}
