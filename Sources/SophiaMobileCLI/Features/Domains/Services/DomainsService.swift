import Foundation

final class DomainsService: DomainServicing {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient  
    }

    func requestDomainsData() async throws(APIError) -> [DomainsModel] {
        do {
            let response: [DomainsModel] = try await apiClient.request(endpoint: "/domains", method: .get, type: [DomainsModel].self)
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