import Foundation

public struct Surah: Codable, Identifiable, Equatable, Hashable {
    public let id: String
    public let number: Int
    public let name: String
    public let nameArabic: String
    public let nameTranslation: String
    public let versesCount: Int
    public let revelationPlace: String
    
    public init(id: String, number: Int, name: String, nameArabic: String, nameTranslation: String, versesCount: Int, revelationPlace: String) {
        self.id = id
        self.number = number
        self.name = name
        self.nameArabic = nameArabic
        self.nameTranslation = nameTranslation
        self.versesCount = versesCount
        self.revelationPlace = revelationPlace
    }
}


