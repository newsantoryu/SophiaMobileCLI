import Foundation

final class InsightsServices {

    let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func requestInsights() async throws -> InsightModel {
        try await apiClient.request(endpoint: "/insights/latest", type: InsightModel.self)
    }

    
}