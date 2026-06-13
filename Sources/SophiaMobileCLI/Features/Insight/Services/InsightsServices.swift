import Foundation

final class InsightsServices {

    let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func requestInsights() async throws(APIError) -> InsightModel {
        do {
            let response: InsightModel = try await apiClient.request(endpoint: "/insights/latest", type: InsightModel.self)
            return response
        } catch {
            if let apiError = error as? APIError {
                throw apiError
            }
            throw APIError.networkError("Error fetching insights: \(error)")
        }
        
    }
    
}