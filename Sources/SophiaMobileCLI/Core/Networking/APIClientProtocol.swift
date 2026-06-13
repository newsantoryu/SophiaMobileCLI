import Foundation

protocol APIClientProtocol:Sendable {
    func request<Response: Decodable>(
        endpoint: String, 
        type:Response.Type
        ) async throws -> Response
    }