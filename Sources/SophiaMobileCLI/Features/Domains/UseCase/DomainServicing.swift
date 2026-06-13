import Foundation

protocol DomainServicing:Sendable {
    func requestDomainsData() async throws(APIError) -> [DomainsModel]
}