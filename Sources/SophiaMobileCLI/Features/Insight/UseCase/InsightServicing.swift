import Foundation

protocol InsightServicing:Sendable {
    func requestInsights() async throws(APIError) -> InsightModel
}