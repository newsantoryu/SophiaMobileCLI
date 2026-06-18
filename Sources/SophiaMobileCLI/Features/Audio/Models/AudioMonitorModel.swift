import Foundation

struct AudioMonitorModel: Codable, Sendable, Equatable {
    let domain: String
    let status: String
    let noiseFloor: Int
    let currentLevel: Int
    let classification: String
    let confidence: Double
    let timestamp: String

    enum CodingKeys: String, CodingKey {
        case domain, status, classification, confidence, timestamp
        case noiseFloor = "noise_floor"
        case currentLevel = "current_level"
    }
}