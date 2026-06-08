import Foundation

protocol APIClientProtocol {
    func request<Response: Decodable>(
        endpoint: String, 
        type:Response.Type
        ) async throws -> Response
    }