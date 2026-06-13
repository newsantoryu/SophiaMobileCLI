import Foundation

final class DomainsService:Sendable {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient  
    }

    func requestDomainsData() async throws -> [DomainsModel] {
        try await apiClient.request(endpoint: "/domains", type: [DomainsModel].self)
    }


}