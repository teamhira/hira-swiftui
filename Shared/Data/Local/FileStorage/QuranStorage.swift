import Foundation

public protocol QuranStorage {
    func saveSurahs(_ surahs: [Surah], language: String)
    func fetchSurahs(language: String) -> [Surah]?
    func clearCache()
}

public class QuranStorageImpl: QuranStorage {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    public init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        self.cacheDirectory = paths[0].appendingPathComponent("QuranCache", isDirectory: true)
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    // MARK: - Surah List Caching
    
    public func saveSurahs(_ surahs: [Surah], language: String) {
        let fileName = "surahs_\(language).json"
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        
        do {
            let data = try JSONEncoder().encode(surahs)
            try data.write(to: fileURL)
        } catch {
            print("❌ QuranStorage: Failed to save surahs for \(language): \(error)")
        }
    }
    
    public func fetchSurahs(language: String) -> [Surah]? {
        let fileName = "surahs_\(language).json"
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let surahs = try JSONDecoder().decode([Surah].self, from: data)
            return surahs
        } catch {
            print("❌ QuranStorage: Failed to fetch surahs for \(language): \(error)")
            return nil
        }
    }
    
    public func clearCache() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
}
