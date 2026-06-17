import Foundation

protocol APIClientProtocol:Sendable {
    func request<Response: Decodable>(
        endpoint: String,
        method: HTTPMethod, 
        type:Response.Type
        ) async throws -> Response
    }