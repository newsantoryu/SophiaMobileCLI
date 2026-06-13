import Foundation

final class PowerService:Sendable {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getPowerDomain() async throws -> PowerModel {
        try await apiClient.request(endpoint: "/cognition/power", type: PowerModel.self)
    }

}