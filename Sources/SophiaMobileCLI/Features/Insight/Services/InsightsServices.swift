import Foundation

final class InsightsServices:InsightServicing {

    let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func requestInsights() async throws(APIError) -> InsightModel {
        do {
            let response: InsightModel = try await apiClient.request(endpoint: "/insights/latest", type: InsightModel.self)
            return response
        } catch let error as APIError {
            throw error
           
        } catch let error as DecodingError {
            throw APIError.decodingError("User error: \(APIError.decodingError(String())) - Swift error: \(error.localizedDescription)")
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }
        
    }
    
}