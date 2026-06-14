import Foundation

protocol PowerServicing: Sendable {
    func getPowerDomain() async throws(APIError) -> PowerModel
    
}