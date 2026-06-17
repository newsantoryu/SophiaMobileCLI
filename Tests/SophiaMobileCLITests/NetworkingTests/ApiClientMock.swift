import Foundation
@testable import SophiaMobileCLI

struct ApiClientMock:APIClientProtocol, Sendable {

    let result: Result<any Sendable, any Error & Sendable>

    init(result: Result<any Sendable, any Error & Sendable>) {
        self.result = result
    }
    
    func request<Response>(endpoint: String, type: Response.Type) async throws -> Response where Response : Decodable {
        switch result {
            case .success(let value):
                guard let responseValue = value as? Response else {
                    throw APIError.decodingError("Mock Retornou:\(Swift.type(of: value))  - Mas esperava: \(Response.self)")
                }
                return responseValue
            case .failure(let error):
                throw error
        }
    }

}