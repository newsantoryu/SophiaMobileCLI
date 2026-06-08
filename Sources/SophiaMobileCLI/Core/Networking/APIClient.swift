import Foundation
import FoundationNetworking // OBRIGATÓRIO no Linux para usar o URLSession.shared

final class APIClient: APIClientProtocol {

    private let enviroment: Environment

    init(enviroment: Environment = .current) {
        self.enviroment = enviroment
    }

    func request<Response: Decodable>(endpoint: String, type: Response.Type) async throws -> Response {
        guard let url = URL(string: endpoint, relativeTo: enviroment.baseUrl ) else {
            throw APIError.invalidResponse
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }

}