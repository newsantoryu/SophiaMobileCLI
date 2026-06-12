import Foundation

struct InsightModel: Codable, Sendable {
    let level: String
    let pattern: String 
    let insight: String
    let suggestion: String
    let observer_confidence: Double 
}

